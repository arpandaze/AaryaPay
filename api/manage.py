import sys
import os
import platform

system = platform.system()

def main(args):
    if args[1] == "dkstart":
        if system == "Darwin":
            os.system("mailhog > /dev/null 2>&1 &")
            os.system(
                "redis-server --appendonly yes --requirepass redispass > /dev/null 2>&1 &"
            )
            os.system(
                "export DATABASE_URL=postgres://postuser:postpass@localhost:5432/actix && sqlx database create && sqlx migrate run"
            )
        else:
            os.system("./scripts/redis.sh")
            os.system("./scripts/postgres.sh")
        exit()

    elif args[1] == "start":
        os.system("air")
        exit()

    elif args[1] == "mig":
        os.system(
            "migrate -source file://migrations -database=postgres://postadmin:postpass@localhost:5432/aaryapay\\?sslmode=disable up"
        )
        exit()

    elif args[1] == "cm":
        os.system(
            "migrate -source file://migrations -database=postgres://postadmin:postpass@localhost:5432/aaryapay\\?sslmode=disable down"
        )
        os.system(
            "migrate -source file://migrations -database=postgres://postadmin:postpass@localhost:5432/aaryapay\\?sslmode=disable up"
        )
        exit()

    print("No args or invalid args provided!")
    print("Available args: dkstart, start, mig, cm")


if __name__ == "__main__":
    main(sys.argv)
