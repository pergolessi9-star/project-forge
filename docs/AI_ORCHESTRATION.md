# AI Orchestration

The AI layer uses a provider adapter interface.

Agents are expected to return structured outputs containing:
- claims
- evidence candidates
- uncertainties
- open questions
- recommended next actions

No agent is authorized to mark a claim as VERIFIED without the human-verification workflow.
