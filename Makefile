.PHONY: help dev dev-fast up down restart logs clean migrate rebuild

# Default target
help:
	@echo "Available commands:"
	@echo "  make dev            - Start development (default) When you want speed (no pgAdmin)"
	@echo "  make dev-fast       - Start without pgAdmin (faster)"
	@echo "  make up             - Start all services"
	@echo "  make down           - Stop all services"
	@echo "  make restart        - Restart app only (Run on Code changes)"
	@echo "  make logs           - Show app logs"
	@echo "  make migrate        - Run migrations"
	@echo "  make clean          - Clean containers/volumes"
	@echo "  make rebuild        - Full rebuild"

# Development mode (most used)
# When you want speed (no pgAdmin)
dev:
	docker compose up app --build 

# Fast development (no pgAdmin)
dev-fast:
	docker compose up db app --build

# Start all services
up:
	docker compose up --build

# Stop services
down:
	docker compose down

# Restart app only
# Run on Code changes
restart:
	docker compose restart app 

# Show logs
logs:
	docker compose logs -f app

# Run migrations
migrate:
	docker compose run --rm migrate

# Clean up
clean:
	docker compose down -v
	docker system prune -f

# Full rebuild when things break
rebuild:
	docker compose down -v
	docker compose build --no-cache app
	docker compose up app