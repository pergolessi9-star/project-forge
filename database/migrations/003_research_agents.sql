-- PROJECT FORGE v0.1.1 — research agent execution and discovery evidence
CREATE TYPE research_run_status AS ENUM ('QUEUED','RUNNING','COMPLETED','FAILED','REVIEW_REQUIRED');
CREATE TYPE research_agent_type AS ENUM ('PROBLEM','MARKET','TECHNOLOGY','REGULATION','SYNTHESIS');

CREATE TABLE research_runs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  agent_type research_agent_type NOT NULL,
  query TEXT NOT NULL,
  status research_run_status NOT NULL DEFAULT 'QUEUED',
  provider TEXT,
  model TEXT,
  started_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  error TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE research_findings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  research_run_id UUID NOT NULL REFERENCES research_runs(id) ON DELETE CASCADE,
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  finding_type TEXT NOT NULL,
  title TEXT NOT NULL,
  claim TEXT NOT NULL,
  confidence NUMERIC(5,2),
  evidence_status evidence_status NOT NULL DEFAULT 'PENDING',
  payload JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE research_citations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  finding_id UUID NOT NULL REFERENCES research_findings(id) ON DELETE CASCADE,
  source_id UUID REFERENCES evidence_sources(id) ON DELETE SET NULL,
  url TEXT,
  locator TEXT,
  excerpt TEXT,
  retrieved_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_research_runs_project_status ON research_runs(project_id,status,created_at DESC);
CREATE INDEX idx_research_findings_project ON research_findings(project_id,created_at DESC);
CREATE INDEX idx_research_citations_finding ON research_citations(finding_id);

INSERT INTO project_gates(project_id,gate_number,gate_code,stage,status)
SELECT p.id, x.n, x.code, x.stage::project_stage, 'PENDING'::gate_status
FROM projects p
CROSS JOIN (VALUES
 (0,'INTAKE','INTAKE'),(1,'PROBLEM_EVIDENCE','PROBLEM'),(2,'MARKET_EVIDENCE','MARKET'),
 (3,'TECHNOLOGY_FEASIBILITY','TECHNOLOGY'),(4,'REGULATORY_FEASIBILITY','REGULATION'),
 (5,'CONCEPT','CONCEPT'),(6,'MVP','MVP'),(7,'VALIDATION','VALIDATION'),(8,'SPECIFICATION','SPECIFICATION')
) x(n,code,stage)
ON CONFLICT (project_id,gate_number) DO NOTHING;
