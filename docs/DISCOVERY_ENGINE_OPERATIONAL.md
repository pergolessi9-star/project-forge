# PROJECT FORGE — Discovery Engine Operational Specification

## Purpose

PROJECT FORGE is discovery-first: research and evidence precede concept, MVP and engineering.

## Operational sequence

`NEW PROJECT → PROBLEM → MARKET → TECHNOLOGY → REGULATION → EVIDENCE → HUMAN VERIFICATION → GATE`

A project advances only through an explicit gate review. AI-generated output is never accepted as verified evidence without human verification.

## Evidence boundary

- `VERIFIED`: human-reviewed and accepted.
- `DERIVED`: derived from verified evidence but not independently verified.
- `DECLARED`: supplied by a project participant.
- `SCENARIO`: hypothetical or exploratory.
- `PENDING`: not yet verified.

## Research agents

| Agent | Mission | Primary entities |
|---|---|---|
| PROBLEM | Establish problem evidence and affected users | problems, customers, evidence |
| MARKET | Research segments, demand, market structure and competitors | markets, competitors, evidence |
| TECHNOLOGY | Assess enabling technologies, maturity and feasibility | technologies, technology_assessments, evidence |
| REGULATION | Identify applicable regulation and requirements | regulations, regulatory_requirements, evidence |

Agents are provider-neutral and use an OpenAI-compatible HTTP interface by default. The provider is selected by environment configuration; no vendor is hard-coded into the domain layer.

## Research lifecycle

1. Create `research_runs` record as `QUEUED`.
2. Set `RUNNING` and invoke the configured provider.
3. Require structured JSON output with claims and citations.
4. Persist `research_findings` and `research_citations`.
5. Keep finding `PENDING` until a human verifies it.
6. Verification can create a corresponding `evidence` record and mark it `VERIFIED` when the reviewer explicitly accepts it.
7. Gate reviews remain human decisions.

## API

- `GET /api/projects/:id/discovery`
- `POST /api/projects/:id/discovery`
- `GET /api/projects/:id/research`
- `POST /api/projects/:id/research`
- `POST /api/projects/:id/research/:runId/findings/:findingId/verify`
- `GET /api/projects/:id/readiness`
- `POST /api/projects/:id/evidence/:evidenceId/verify`
- `POST /api/projects/:id/gates/:gateNumber/review`

## Configuration

Required for live AI execution:

- `AI_API_KEY`
- `AI_MODEL`
- optional `AI_BASE_URL`

No secrets belong in Git. Production credentials must be supplied through the deployment environment.

## Production boundary

Database migrations remain canonical SQL and are executed by `npm run db:migrate`. Drizzle is an application mapping layer, not the source of truth. Vercel deployment can be connected once the production `DATABASE_URL` and AI credentials are supplied.
