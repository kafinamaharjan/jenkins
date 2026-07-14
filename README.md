# String Theory Guitar Shop

A full-stack guitar store with an Express API, PostgreSQL persistence, Docker Compose, and Jenkins pipeline.

## Run locally

```bash
docker compose up --build
```

Open http://localhost:3000. The database is seeded automatically on its first startup.

## API

- `GET /api/products` — catalog
- `POST /api/orders` — accepts `customerName`, `email`, and `items` (`id`, `quantity`)

For non-container development, copy `.env.example` to `.env`, run `npm install`, then `npm start`.
