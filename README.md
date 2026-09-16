# PROJECT FORGE

**Discovery Engine v0.1.0**

PROJECT FORGE is an evidence-first project discovery platform:
Idea → Discovery → Evidence → Human Verification → Concept → MVP → Validation → Product Specification.

## Foundation

- Next.js + TypeScript
- PostgreSQL
- Drizzle ORM
- Zod
- Provider-agnostic AI orchestration
- REST/JSON API
- Evidence and human-verification boundary
- Audit trail
- Initial dashboard

## Quick start

```bash
cp .env.example .env.local
npm install
npm run dev
```

Database migration:

```bash
npm run db:migrate
npm run db:seed
```

Open `http://localhost:3000`.

## Principle

> Evidence before Engineering.

AI-generated output is never treated as verified fact without an evidence record and human verification.
