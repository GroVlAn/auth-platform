# Auth platform

A production-oriented authorization platform built with Go and a microservice architecture.

The platform provides authentication, authorization (RBAC), API Gateway, JWT token management, gRPC communication between services, and centralized secrets management with HashiCorp Vault.

Go | gRPC | PostgreSQL | Redis | Vault | Docker | Swagger

## About

Auth Platform is a modular authorization platform designed as a collection of independent microservices.

The project demonstrates how a real-world authentication system can be built using modern backend technologies and production-oriented architecture.

Main goals of the project:

- JWT authentication
- Refresh Token Rotation
- Role Based Access Control (RBAC)
- API Gateway
- gRPC communication
- independent databases
- centralized secret management
- Docker deployment

## Architecture

> **Architecture diagram**

![Architecture](architecture/architecture.png)

## Services

| Service                                                                                                       | Responsibility        |
| ------------------------------------------------------------------------------------------------------------- | --------------------- |
| [auth-api-gateway](https://github.com/GroVlAn/auth-api-gateway/tree/01a7e5dd9c1f98104cdaa109115a08fbfa17759f) | HTTP/gRPC Gateway     |
| [auth-auth](https://github.com/GroVlAn/auth-auth/tree/f70921dfaeaa90d1b58c0c3647e9fe693a9d264d)               | Authentication        |
| [auth-user](https://github.com/GroVlAn/auth-user/tree/9617ab6b582f1fe4c73495be7dc0f9785dc35fce)               | User management       |
| [auth-access](https://github.com/GroVlAn/auth-access/tree/26d8ba8184606c233b62a373b2d76d85f182f0a5)           | Roles and Permissions |
| [auth-api](https://github.com/GroVlAn/auth-api/tree/f0aed1b91f2149de43ba4676e8602a3a17e00fad)                 | gRPC contracts        |
| [auth-base](https://github.com/GroVlAn/auth-base/tree/e621964a91bfa2c9bcedfc3198d5e9164354ae79)               | Shared libraries      |
| [auth-open-api](https://github.com/GroVlAn/auth-open-api/tree/87ccfbb172bfa1354d99942f198318046543196a)       | Swagger/OpenAPI       |

## Features

- JWT Authentication
- Refresh Token Rotation
- Access Token Validation
- RBAC
- Role Management
- Permission Management
- API Gateway
- gRPC
- PostgreSQL
- Redis
- Vault
- Swagger UI
- Docker Compose

## Tech Stack

Backend

- Go
- Chi
- gRPC
- sqlx

Databases

- PostgreSQL
- Redis

Infrastructure

- Docker
- Docker Compose
- Vault

Documentation

- Swagger/OpenAPI

## Project Structure

```text
auth-platform
│
├── docker-compose.yml
├── example.env
├── README.md
│
├── services
│   ├── auth-api-gateway
│   ├── auth-auth
│   ├── auth-user
│   ├── auth-access
│   ├── auth-api
│   ├── auth-base
│   └── auth-open-api
│
├── architecture
│
└── docs
```

## Configuration

All services are configured via environment variables. A template is provided in `example.env` – copy it to `.env` and adjust the values:

```bash
cp example.env .env
```

| Variable                                                                                     | Description                                                                                                                                      | Default / Example   |
| -------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------- |
| **General**                                                                                  |
| SECRET_KEY                                                                                   | Secret key for signing JWT tokens. Must be a strong, random string. Change this in production.                                                   | your-secret-key     |
| TOKEN_ACCESS_END_TTL                                                                         | Access token lifetime (seconds).                                                                                                                 | 900 (15 min)        |
| TOKEN_REFRESH_END_TTL                                                                        | Refresh token lifetime (seconds).                                                                                                                | 2592000 (30 days)   |
| **Redis**                                                                                    |
| AUTH_REDIS_HOST                                                                              | Redis hostname or IP.                                                                                                                            | redis               |
| AUTH_REDIS_ADDR                                                                              | Redis port.                                                                                                                                      | 6379                |
| AUTH_REDIS_PASSWORD                                                                          | Redis password. Set a strong password for production.                                                                                            | your-redis-password |
| AUTH_REDIS_DB                                                                                | Redis database number.                                                                                                                           | 1                   |
| **PostgreSQL (auth-access)**                                                                 |
| DB_ACCESS_USERNAME                                                                           | Database username for the auth-access service.                                                                                                   | admin               |
| DB_ACCESS_PASSWORD                                                                           | Database password – must be changed.                                                                                                             | –                   |
| DB_ACCESS_DB_NAME                                                                            | Database name for roles/permissions.                                                                                                             | auth_access         |
| **Argon2 Hashing**                                                                           |
| HASH_TIME, HASH_MEMORY, HASH_THREADS, HASH_KEY_LEN, HASH_SALT_LEN                            | Parameters for password hashing (Argon2id). Usually keep defaults unless you need to tune performance/security.                                  | See example.env     |
| **Vault**                                                                                    |
| VAULT_DEV_ADDR                                                                               | Vault server address (HTTP URL).                                                                                                                 | http://vault:8200   |
| VAULT_DEV_SECRET_TOKEN                                                                       | Vault token for development. Replace with a proper token in production.                                                                          | root                |
| VAULT_MOUNT                                                                                  | Mount path where secrets are stored.                                                                                                             | secret              |
| **Vault Secret Paths**                                                                       |
| AUTH_TOKEN_PATH, AUTH_REDIS_PATH, AUTH_HASHER_PATH, ACCESS_POSTGRES_PATH, USER_POSTGRES_PATH | Internal paths inside Vault for storing specific secrets (JWT keys, Redis credentials, hasher params, database credentials). Usually left as is. | See example.env     |

> Important: For production, never use default passwords or the example SECRET_KEY. Generate strong random values for all secrets and store them securely (e.g., in Vault). The provided example.env is only for local development.

> The `bootstrap-vault` service automatically populates Vault with the required secrets (database credentials, Redis password, hashing parameters) from the environment. It runs once after Vault is healthy.

## Quick Start

### Clone repository

git clone ...

### Initialize Git submodules

git submodule update --init --recursive

### Copy environment variables

cp example.env .env

### Build project

docker compose up --build

### Open Swagger

http://localhost:8001

## Service Ports

When running with Docker Compose, the following ports are exposed:

| Service             | Port(s)                           | Purpose                                                  |
| ------------------- | --------------------------------- | -------------------------------------------------------- |
| API Gateway         | `9080` (HTTP/REST), `9010` (gRPC) | Main entry point for client requests.                    |
| Auth Service        | `9011` (gRPC)                     | Authentication logic (login, token validation, refresh). |
| User Service        | `9012` (gRPC)                     | User management (CRUD, profile, status).                 |
| Access Service      | `9013` (gRPC)                     | Role and permission management (RBAC).                   |
| Swagger UI          | `8001`                            | OpenAPI interactive documentation.                       |
| PostgreSQL (user)   | `5433`                            | User database (only for internal use).                   |
| PostgreSQL (access) | `5435`                            | Access database (roles/permissions).                     |
| Redis               | `6380`                            | Session and refresh token cache.                         |
| Vault               | `8200`                            | Secrets management UI and API.                           |

All services communicate over the internal Docker network `auth-network`. Only the API Gateway, Swagger, and Vault (optionally) are exposed to the host.

## Database Migrations

Migrations are applied automatically on startup using the `migration_user` and `migration_access` containers. They run before the respective services start, ensuring the schemas are up‑to‑date.

If you need to run migrations manually, you can use the `migrate` tool with the same connection strings as defined in `docker-compose.yaml`.

## Login sequence

> **Login sequence diagram**

![Login sequence](architecture/login-sequence.png)

## Authorization sequence

> **Authorization sequence diagram**

![Authorization sequence](architecture/authorization-sequence.png)

## Database schema

> **Database schema diagram**

![Database schema](architecture/database-schema.png)

## License

This project is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.

You are free to use, modify, distribute, and sublicense the code for both commercial and non‑commercial purposes, provided that the original copyright notice and permission notice are included in all copies or substantial portions of the software.

For more information, see the full [MIT License](https://opensource.org/licenses/MIT).
