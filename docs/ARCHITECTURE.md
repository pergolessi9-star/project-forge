# Architecture

PROJECT FORGE has four boundaries: Presentation; API/domain services; Evidence/AI orchestration; PostgreSQL persistence.

AI providers are adapters behind an orchestrator. Evidence and human review form the governance boundary between discovery and engineering.

Repository layers: `app/`, `components/`, `core/`, `domain/`, `schemas/`, `database/`, `ai/`, `connectors/`, `jobs/`, `docs/`, `tests/`.
