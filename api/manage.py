import os
import platform
import sys

system = platform.system()


def main(args):
    if args[1] == "dkstart":
        if system == "Darwin":
            os.system("mailhog > /dev/null 2>&1 &")
            os.system("redis-server --requirepass redispass > /dev/null 2>&1 &")
            os.system(
                "migrate -source file://migrations -database=postgres://postadmin:postpass@localhost:5432/aaryapay\\?sslmode=disable up"
            )
        else:
            os.system("./scripts/redis.sh")
            os.system("./scripts/postgres.sh")
            os.system("./scripts/fileserver.sh")
            os.system("./scripts/mailpit.sh")
        exit()

    elif args[1] == "start":
        os.system("air")
        exit()

    elif args[1] == "remake":
        os.system("yes | python manage.py cm && python manage.py populate")
        exit()

    elif args[1] == "mig":
        os.system(
            "migrate -source file://migrations -database=postgres://postadmin:postpass@localhost:5432/aaryapay\\?sslmode=disable up"
        )
        os.system(
            "migrate -source file://migrations -database=postgres://postadmin:postpass@localhost:5432/aaryapaytest\\?sslmode=disable up"
        )
        exit()

    elif args[1] == "cm":
        os.system(
            "migrate -source file://migrations -database=postgres://postadmin:postpass@localhost:5432/aaryapay\\?sslmode=disable down"
        )
        os.system(
            "migrate -source file://migrations -database=postgres://postadmin:postpass@localhost:5432/aaryapay\\?sslmode=disable up"
        )

        os.system(
            "migrate -source file://migrations -database=postgres://postadmin:postpass@localhost:5432/aaryapaytest\\?sslmode=disable down"
        )
        os.system(
            "migrate -source file://migrations -database=postgres://postadmin:postpass@localhost:5432/aaryapaytest\\?sslmode=disable up"
        )
        exit()

    elif args[1] == "test":
        os.system(
            "yes | migrate -source file://migrations -database=postgres://postadmin:postpass@localhost:5432/aaryapaytest\\?sslmode=disable down"
        )
        os.system(
            "migrate -source file://migrations -database=postgres://postadmin:postpass@localhost:5432/aaryapaytest\\?sslmode=disable up"
        )
        os.system("go clean -testcache")

        os.system("go test ./... " + " ".join(args[2:]))
        exit()

    elif args[1] == "populate":
        os.system("go run population/populate.go")
        exit()

    elif args[1] == "dpopulate":
        os.system("MODE=staging-remote go run population/populate.go")
        exit()

    elif args[1] == "dcm":
        os.system(
            "migrate -source file://migrations -database=postgres://postadmin:11227f9c054247bdb73af64b6a779c0d@arpandaze.tech:5432/aaryapay\\?sslmode=disable down"
        )
        os.system(
            "migrate -source file://migrations -database=postgres://postadmin:11227f9c054247bdb73af64b6a779c0d@arpandaze.tech:5432/aaryapay\\?sslmode=disable up"
        )
        exit()

    elif args[1] == "dremake":
        os.system("yes | python manage.py dcm && python manage.py dpopulate")
        exit()

    print("No args or invalid args provided!")
    print("Available args: dkstart, start, mig, cm")


if __name__ == "__main__":
    main(sys.argv)
