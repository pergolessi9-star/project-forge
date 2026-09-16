# PROJECT FORGE v0.1 — PostgreSQL + Vercel deployment

## 1. PostgreSQL
Set `DATABASE_URL` to the production PostgreSQL connection string.

Run:

```bash
npm install
npm run db:migrate
npm run db:seed
npm run build
```

The SQL files under `database/migrations/` are the canonical database contract. Do not use `drizzle-kit push` as a substitute for the canonical migration runner.

## 2. Vercel
Import the GitHub repository and deploy branch `foundation-v0.1` for the first validation deployment. Add `DATABASE_URL` as a Vercel Environment Variable for Preview and Production. Add AI/search/storage secrets only when those connectors are activated.

The dashboard is explicitly dynamic and reads live PostgreSQL data. `/api/health` verifies database connectivity.

## 3. Smoke tests
- `GET /api/health` returns `database: connected`.
- `GET /api/projects` returns projects and `evidence_count`.
- `POST /api/projects` creates a project.
- `GET /api/projects/:id` reads it.
- `PATCH /api/projects/:id` updates it.
- `DELETE /api/projects/:id` removes it.
- `GET /api/evidence?projectId=<uuid>` filters evidence.
- `POST /api/evidence` creates evidence.

## 4. Discovery boundary
AI output remains separate from accepted evidence. Material claims must retain source traceability and human verification where required before becoming accepted project knowledge.
