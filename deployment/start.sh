set -e

./launch_postgres.sh
./launch_redis.sh
./launch_mailpit.sh
./launch_fileserver.sh
./launch_backend.sh
./launch_proxy.sh
