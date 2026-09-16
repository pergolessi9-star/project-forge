# PROJECT FORGE v0.1 — Technical Specification

## Mission

PROJECT FORGE is an evidence-first discovery engine. It separates project discovery from product engineering.

## Core lifecycle

Idea → Discovery → Evidence Register → Human Verification → Project Concept → MVP → Validation → Product Specification → Engineering Handoff.

## Evidence boundary

Evidence states:
- VERIFIED
- DERIVED
- DECLARED
- SCENARIO
- PENDING

AI output is never implicitly promoted to VERIFIED.

## Domains

Projects, problems, customers, markets, competitors, technologies, regulations, scientific claims, research, funding, evidence, concepts, MVPs, validation, risks, IP, sovereignty, decisions, gates, AI runs, human reviews and audit trail.

## Engineering principle

Provider-agnostic AI orchestration. The application domain must not import a vendor-specific SDK directly.

## Initial API

- GET/POST `/api/projects`
- GET `/api/evidence`
- GET `/api/health`

Additional domain endpoints are reserved for v0.2+ and can be added without changing the core data contract.

## Initial gates

0. INTAKE
1. PROBLEM_EVIDENCE
2. MARKET_EVIDENCE
3. TECHNOLOGY_FEASIBILITY
4. REGULATORY_FEASIBILITY
5. CONCEPT
6. MVP
7. VALIDATION
8. SPECIFICATION

Gate outcomes: PENDING, READY, ADVANCE, HOLD, REWORK, REJECT.
