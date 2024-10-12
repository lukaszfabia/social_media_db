# !/bin/bash


if ! command -v docker-compose >/dev/null 2>&1; then
    sudo apt update
    sudo apt install -y docker-compose
fi

echo "$(docker-compose -v)"

if [ -f "$(pwd)/.env" ]; then
    docker-compose --env-file .env up
else
    touch .env
    echo -e "POSTGRES_USER=$(whoami)\nPOSTGRES_PASSWORD=\nPOSTGRES_DB=\n" > .env
    echo ".env file created $(pwd). Please re-run when you make sure that env vars are proper!"
fi