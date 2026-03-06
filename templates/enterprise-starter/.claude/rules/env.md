# Environment Variables

> [CUSTOMIZE THIS FILE] Document every environment variable in this project. Keep this updated whenever variables are added, removed, or changed.
> Agents use this file to understand what configuration exists and how to reference it correctly.

## Setup

1. Copy `.env.example` to `.env.local` (for local development)
2. Never commit `.env`, `.env.local`, or any file with real secrets to git
3. For production, set variables in [your secret manager — e.g., Vercel Dashboard / GitHub Secrets / AWS SSM]

## Application

| Variable | Required | Description | Example |
|---|---|---|---|
| `NODE_ENV` | Yes | Runtime environment | `development` / `production` / `test` |
| `PORT` | No | Server port (defaults to 3000) | `3000` |
| `APP_URL` | Yes | Public-facing base URL | `https://app.example.com` |
| `LOG_LEVEL` | No | Logging verbosity | `info` / `debug` / `error` |

## Database

| Variable | Required | Description | Example |
|---|---|---|---|
| `DATABASE_URL` | Yes | Primary database connection string | `postgresql://user:pass@host:5432/dbname` |
| `DATABASE_POOL_MIN` | No | Min connection pool size | `2` |
| `DATABASE_POOL_MAX` | No | Max connection pool size | `10` |

## Authentication

| Variable | Required | Description | Where to get it |
|---|---|---|---|
| `AUTH_SECRET` | Yes | Secret for signing sessions/JWTs | Generate: `openssl rand -base64 32` |
| `AUTH_URL` | Yes | Canonical URL for auth callbacks | Same as `APP_URL` |
| `[OAUTH_PROVIDER]_CLIENT_ID` | If OAuth | OAuth app client ID | [Provider] dashboard |
| `[OAUTH_PROVIDER]_CLIENT_SECRET` | If OAuth | OAuth app secret | [Provider] dashboard |

## External Services

> [Add rows for each service this project integrates with]

| Variable | Required | Description | Where to get it |
|---|---|---|---|
| `STRIPE_SECRET_KEY` | If billing | Stripe API key | Stripe Dashboard → API Keys |
| `STRIPE_WEBHOOK_SECRET` | If billing | Webhook signing secret | Stripe Dashboard → Webhooks |
| `SENDGRID_API_KEY` | If email | Email sending API key | SendGrid Dashboard |
| `S3_BUCKET` | If file storage | AWS S3 bucket name | AWS Console |
| `AWS_ACCESS_KEY_ID` | If AWS | AWS credentials | AWS IAM |
| `AWS_SECRET_ACCESS_KEY` | If AWS | AWS credentials | AWS IAM |
| `AWS_REGION` | If AWS | AWS region | e.g., `us-east-1` |

## Feature Flags

| Variable | Required | Description | Values |
|---|---|---|---|
| `FEATURE_[NAME]` | No | Enable experimental feature | `true` / `false` |

## Local Development Overrides

These variables can be set in `.env.local` to override defaults for local development:

```bash
# .env.example — copy to .env.local and fill in real values

NODE_ENV=development
PORT=3000
APP_URL=http://localhost:3000

DATABASE_URL=postgresql://postgres:postgres@localhost:5432/[PROJECT_NAME]_dev

AUTH_SECRET=dev-secret-change-in-production
AUTH_URL=http://localhost:3000

# Add other variables below
```

## CI/CD Variables

Variables set in the CI/CD system (not in `.env` files):

| Variable | Set in | Purpose |
|---|---|---|
| `DATABASE_URL` | [CI Secret / Vault] | Test database connection |
| `[OTHER_VAR]` | [CI Secret / Vault] | [Purpose] |
