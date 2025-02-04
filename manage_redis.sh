#!/bin/bash

# Set the base directory for the script
BASE_DIR=$(dirname "$0")

# Set environment (default to QA if no argument is provided)
ENV=${1:-qa}
COMPOSE_FILE=""

# Validate environment
if [[ "$ENV" == "qa" ]]; then
    # NOTE: Uncomment Below If QA Server Was Setup
    # COMPOSE_FILE="${BASE_DIR}/docker/qa/docker-compose-qa.yml"
    COMPOSE_FILE="${BASE_DIR}/docker-compose.yml"
elif [[ "$ENV" == "prod" ]]; then
    COMPOSE_FILE="${BASE_DIR}/docker-compose.yml"
else
    echo "Invalid environment! Use 'qa' or 'prod'."
    exit 1
fi

# Check if a command is provided
if [ -z "$2" ]; then
    echo "Usage: $0 <environment: qa|prod> <command: build|up|logs|down>"
    exit 1
fi

# Get the command (e.g., build, up, logs, down)
COMMAND=$2

# Function to replace ${REDIS_PASSWORD} in redis.conf
replace_redis_password() {
    local env_file="${BASE_DIR}/.env"
    local redis_conf="${BASE_DIR}/redis.conf"

    if [ ! -f "$env_file" ]; then
        echo "Error: .env file not found at $env_file"
        exit 1
    fi

    if [ ! -f "$redis_conf" ]; then
        echo "Error: redis.conf file not found at $redis_conf"
        exit 1
    fi

    # Read REDIS_PASSWORD from .env file
    source "$env_file"

    if [ -z "$REDIS_PASSWORD" ]; then
        echo "Error: REDIS_PASSWORD not set in .env file"
        exit 1
    fi

    # Replace ${REDIS_PASSWORD} in redis.conf with the actual password
    sed -i "s/\${REDIS_PASSWORD}/$REDIS_PASSWORD/g" "$redis_conf"
    echo "Updated redis.conf with REDIS_PASSWORD"
}

# Execute the command
case $COMMAND in
    build)
        echo "Building containers for $ENV..."
        docker-compose -f "$COMPOSE_FILE" build --no-cache
        ;;
    up)
        echo "Building and starting containers for $ENV in detached mode..."
        replace_redis_password
        docker-compose -f "$COMPOSE_FILE" up -d
        ;;
    logs)
        echo "Tailing logs for $ENV..."
        docker-compose -f "$COMPOSE_FILE" logs -tf
        ;;
    down)
        echo "Stopping containers and cleaning up resources for $ENV..."
        docker-compose -f "$COMPOSE_FILE" down --remove-orphans --volumes --rmi all
        ;;
    *)
        echo "Invalid command! Use one of: build, up, logs, down"
        exit 1
        ;;
esac

exit 0