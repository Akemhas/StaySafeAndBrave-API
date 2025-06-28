.PHONY: help build up down restart logs shell clean migrate revert rebuild

# Default target
help:
	@echo "Available commands:"
	@echo "  make build     - Build all containers"
	@echo "  make up        - Start the application"
	@echo "  make down      - Stop all containers"
	@echo "  make restart   - Restart the application"
	@echo "  make logs      - Show application logs"
	@echo "  make shell     - Open shell in app container"
	@echo "  make clean     - Remove containers and volumes"
	@echo "  make migrate   - Run database migrations"
	@echo "  make revert    - Revert database migrations"
	@echo "  make rebuild   - Full rebuild (down, build, up)"
	@echo "  make dev       - Start in development mode"

# Build containers
build:
	docker compose build

# Start application
up:
	docker compose up app

# Start in development mode with logs
dev:
	docker compose up app --build

# Stop containers
down:
	docker compose down

# Restart application
restart:
	docker compose restart app

# Show logs
logs:
	docker compose logs -f app

# Open shell in app container
shell:
	docker compose exec app /bin/bash

# Clean up everything
clean:
	docker compose down -v
	docker system prune -f

# Run migrations
migrate:
	docker compose run migrate

# Revert migrations
revert:
	docker compose run revert

# Full rebuild
rebuild:
	docker compose down
	docker compose build --no-cache
	docker compose up app

dcrebuild:
	docker-compose down
	docker-compose build --no-cache
	docker-compose up app

# Quick restart for development
quick:
	docker compose restart app && docker compose logs -f app