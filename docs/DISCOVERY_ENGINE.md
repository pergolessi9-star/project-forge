# PROJECT FORGE — Discovery Engine

## Operational sequence

`NEW PROJECT → PROBLEM → MARKET → TECHNOLOGY → REGULATION → EVIDENCE → HUMAN VERIFICATION → GATE`

The engine is discovery-first: engineering is downstream of evidence and validation.

## Evidence boundary

Every claim is explicitly classified as `VERIFIED`, `DERIVED`, `DECLARED`, `SCENARIO`, or `PENDING`. AI-generated output never becomes verified evidence automatically.

## API

- `GET /api/projects/:id/discovery` — complete discovery state.
- `POST /api/projects/:id/discovery` — create `problem`, `customer`, `market`, `competitor`, `technology`, `regulation`, `source`, or `evidence` records. Body: `{ "type": "problem", "data": {...} }`.
- `POST /api/projects/:id/evidence/:evidenceId/verify` — human verification. Decision: `ACCEPT`, `REJECT`, `REQUEST_CHANGES`.
- `POST /api/projects/:id/gates/:gateNumber/review` — human gate review. `ADVANCE` moves the project to the next canonical stage.
- `GET /api/projects/:id/agents` — available discovery agents.
- `POST /api/projects/:id/agents` — queue a provider-neutral research task.

## First research agents

1. `problem-research`
2. `market-research`
3. `technology-research`
4. `regulation-research`

Each agent receives the current discovery state and an explicit governance boundary. Provider execution is deliberately separated from agent definitions so PROJECT FORGE is not coupled to a single model vendor.

## Gate model

0. INTAKE
1. PROBLEM_EVIDENCE
2. MARKET_EVIDENCE
3. TECHNOLOGY_FEASIBILITY
4. REGULATORY_FEASIBILITY
5. CONCEPT
6. MVP
7. VALIDATION
8. SPECIFICATION

`ADVANCE` is the only gate decision that moves the project forward automatically; `HOLD`, `REWORK`, and `REJECT` preserve the current stage.
