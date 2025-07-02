# SafeAndBrave

A project built with the Vapor web framework.

## Prerequisites

- Docker
- Docker Compose

## Getting Started

This project uses Docker Compose for development.

### First Time Setup

1. Clone the repository
2. Make sure Docker is running on your system
3. Start the development environment:
   ```bash
   make dev
   ```

This will build and start the necessary containers. The first run may take a few minutes to download and build images.

### Development Commands

Use the following Make commands to manage the application:

### Development Commands

```bash
make dev        # Start development (default) When you want speed (no pgAdmin)
make dev-fast   # Start without pgAdmin (faster)
make up         # Start all services
make down       # Stop all services
make restart    # Restart app only (Run on Code changes)
make logs       # Show app logs
make migrate    # Run migrations
make clean      # Clean containers/volumes
make rebuild    # Full rebuild
```

### Common Workflow

1. Start development environment:
   ```bash
   make dev
   ```

2. View logs:
   ```bash
   make logs
   ```

3. Restart after code changes:
   ```bash
   make restart
   ```

4. Stop services:
   ```bash
   make down
   ```

### See more

- [Vapor Website](https://vapor.codes)
- [Vapor Documentation](https://docs.vapor.codes)
- [Vapor GitHub](https://github.com/vapor)
- [Vapor Community](https://github.com/vapor-community)