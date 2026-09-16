-- PROJECT FORGE v0.1 initial schema
-- Discovery-first project intelligence platform
-- Evidence boundary: VERIFIED | DERIVED | DECLARED | SCENARIO | PENDING

CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE TYPE evidence_status AS ENUM ('VERIFIED','DERIVED','DECLARED','SCENARIO','PENDING');
CREATE TYPE project_status AS ENUM ('IDEA','DISCOVERY','EVIDENCE_REVIEW','CONCEPT','MVP','VALIDATION','SPECIFICATION','ENGINEERING','ARCHIVED','REJECTED');
CREATE TYPE project_stage AS ENUM ('INTAKE','PROBLEM','MARKET','TECHNOLOGY','REGULATION','EVIDENCE','CONCEPT','MVP','VALIDATION','SPECIFICATION');
CREATE TYPE gate_status AS ENUM ('PENDING','READY','ADVANCE','HOLD','REWORK','REJECT');

CREATE TABLE projects (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  description TEXT,
  status project_status NOT NULL DEFAULT 'IDEA',
  current_stage project_stage NOT NULL DEFAULT 'INTAKE',
  owner TEXT,
  confidence NUMERIC(5,2),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE project_versions (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE, version_no INTEGER NOT NULL, snapshot JSONB NOT NULL, created_at TIMESTAMPTZ NOT NULL DEFAULT now(), UNIQUE(project_id,version_no));
CREATE TABLE project_ideas (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE, statement TEXT NOT NULL, source_evidence_id UUID, created_at TIMESTAMPTZ NOT NULL DEFAULT now());
CREATE TABLE problems (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE, statement TEXT NOT NULL, severity INTEGER, evidence_status evidence_status NOT NULL DEFAULT 'PENDING');
CREATE TABLE customers (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE, name TEXT NOT NULL, segment TEXT, need TEXT, evidence_status evidence_status NOT NULL DEFAULT 'PENDING');
CREATE TABLE markets (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE, name TEXT NOT NULL, geography TEXT, tam NUMERIC, sam NUMERIC, som NUMERIC, growth_rate NUMERIC, evidence_status evidence_status NOT NULL DEFAULT 'PENDING');
CREATE TABLE competitors (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE, name TEXT NOT NULL, url TEXT, positioning TEXT, strengths TEXT, weaknesses TEXT, evidence_status evidence_status NOT NULL DEFAULT 'PENDING');
CREATE TABLE technologies (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE, name TEXT NOT NULL, maturity TEXT, description TEXT, evidence_status evidence_status NOT NULL DEFAULT 'PENDING');
CREATE TABLE technology_assessments (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), technology_id UUID NOT NULL REFERENCES technologies(id) ON DELETE CASCADE, feasibility NUMERIC(5,2), readiness NUMERIC(5,2), dependencies TEXT, risks TEXT, evidence_status evidence_status NOT NULL DEFAULT 'PENDING');
CREATE TABLE regulations (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE, name TEXT NOT NULL, jurisdiction TEXT, applicability TEXT, evidence_status evidence_status NOT NULL DEFAULT 'PENDING');
CREATE TABLE regulatory_requirements (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), regulation_id UUID NOT NULL REFERENCES regulations(id) ON DELETE CASCADE, requirement TEXT NOT NULL, applicability_status TEXT, evidence_status evidence_status NOT NULL DEFAULT 'PENDING');
CREATE TABLE scientific_claims (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE, claim TEXT NOT NULL, confidence NUMERIC(5,2), evidence_status evidence_status NOT NULL DEFAULT 'PENDING');
CREATE TABLE research_items (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE, title TEXT NOT NULL, abstract TEXT, source_url TEXT, publication_date DATE, evidence_status evidence_status NOT NULL DEFAULT 'PENDING');
CREATE TABLE evidence_sources (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE, title TEXT NOT NULL, source_type TEXT, source_url TEXT, publisher TEXT, retrieved_at TIMESTAMPTZ, metadata JSONB);
CREATE TABLE evidence (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE, source_id UUID REFERENCES evidence_sources(id), claim TEXT NOT NULL, status evidence_status NOT NULL DEFAULT 'PENDING', confidence NUMERIC(5,2), excerpt TEXT, locator TEXT, created_at TIMESTAMPTZ NOT NULL DEFAULT now());
CREATE TABLE evidence_verifications (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), evidence_id UUID NOT NULL REFERENCES evidence(id) ON DELETE CASCADE, reviewer TEXT NOT NULL, decision TEXT NOT NULL, rationale TEXT, reviewed_at TIMESTAMPTZ NOT NULL DEFAULT now());
CREATE TABLE funding_programmes (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), name TEXT NOT NULL, description TEXT, source_url TEXT);
CREATE TABLE funding_opportunities (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), programme_id UUID REFERENCES funding_programmes(id), name TEXT NOT NULL, deadline DATE, budget NUMERIC, eligibility TEXT, source_url TEXT);
CREATE TABLE project_concepts (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE, title TEXT NOT NULL, executive_summary TEXT, value_proposition TEXT, novelty TEXT, target_customer TEXT, concept_status TEXT DEFAULT 'DRAFT');
CREATE TABLE mvp_definitions (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE, scope TEXT NOT NULL, capabilities JSONB, acceptance_criteria JSONB, dependencies JSONB);
CREATE TABLE validation_experiments (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE, name TEXT NOT NULL, hypothesis TEXT NOT NULL, method TEXT, success_criteria TEXT, status TEXT DEFAULT 'PLANNED');
CREATE TABLE validation_results (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), experiment_id UUID NOT NULL REFERENCES validation_experiments(id) ON DELETE CASCADE, result TEXT, metrics JSONB, conclusion TEXT, evidence_status evidence_status NOT NULL DEFAULT 'PENDING');
CREATE TABLE project_risks (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE, description TEXT NOT NULL, likelihood INTEGER, severity INTEGER, mitigation TEXT, status TEXT DEFAULT 'OPEN');
CREATE TABLE ip_assets (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE, name TEXT NOT NULL, asset_type TEXT, owner TEXT, protection_status TEXT, evidence_status evidence_status NOT NULL DEFAULT 'PENDING');
CREATE TABLE sovereignty_assessments (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE, dimension TEXT NOT NULL, score NUMERIC(5,2), assessment TEXT, evidence_status evidence_status NOT NULL DEFAULT 'PENDING');
CREATE TABLE open_questions (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE, question TEXT NOT NULL, priority INTEGER DEFAULT 3, status TEXT DEFAULT 'OPEN', answer TEXT);
CREATE TABLE decisions (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE, decision TEXT NOT NULL, rationale TEXT, decided_by TEXT, decided_at TIMESTAMPTZ NOT NULL DEFAULT now());
CREATE TABLE decision_evidence (decision_id UUID NOT NULL REFERENCES decisions(id) ON DELETE CASCADE, evidence_id UUID NOT NULL REFERENCES evidence(id) ON DELETE CASCADE, PRIMARY KEY(decision_id,evidence_id));
CREATE TABLE project_gates (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE, gate_number INTEGER NOT NULL, gate_code TEXT NOT NULL, stage project_stage NOT NULL, status gate_status NOT NULL DEFAULT 'PENDING', UNIQUE(project_id,gate_number));
CREATE TABLE gate_reviews (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), gate_id UUID NOT NULL REFERENCES project_gates(id) ON DELETE CASCADE, reviewer TEXT NOT NULL, status gate_status NOT NULL, rationale TEXT, reviewed_at TIMESTAMPTZ NOT NULL DEFAULT now());
CREATE TABLE ai_runs (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE, provider TEXT NOT NULL, model TEXT, task TEXT NOT NULL, status TEXT DEFAULT 'STARTED', started_at TIMESTAMPTZ NOT NULL DEFAULT now(), completed_at TIMESTAMPTZ);
CREATE TABLE ai_outputs (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), ai_run_id UUID NOT NULL REFERENCES ai_runs(id) ON DELETE CASCADE, output_type TEXT NOT NULL, content JSONB NOT NULL, confidence NUMERIC(5,2));
CREATE TABLE ai_sources (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), ai_output_id UUID NOT NULL REFERENCES ai_outputs(id) ON DELETE CASCADE, evidence_id UUID REFERENCES evidence(id));
CREATE TABLE human_reviews (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE, target_type TEXT NOT NULL, target_id UUID NOT NULL, reviewer TEXT NOT NULL, decision TEXT NOT NULL, rationale TEXT, reviewed_at TIMESTAMPTZ NOT NULL DEFAULT now());
CREATE TABLE audit_trail (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), project_id UUID REFERENCES projects(id) ON DELETE SET NULL, actor TEXT NOT NULL, action TEXT NOT NULL, entity_type TEXT, entity_id UUID, payload JSONB, created_at TIMESTAMPTZ NOT NULL DEFAULT now());

CREATE INDEX idx_projects_status ON projects(status);
CREATE INDEX idx_projects_stage ON projects(current_stage);
CREATE INDEX idx_evidence_project_status ON evidence(project_id,status);
CREATE INDEX idx_evidence_claim_trgm ON evidence USING gin (claim gin_trgm_ops);
CREATE INDEX idx_research_project ON research_items(project_id);
CREATE INDEX idx_questions_project_status ON open_questions(project_id,status);
CREATE INDEX idx_audit_project_time ON audit_trail(project_id,created_at DESC);
CREATE INDEX idx_gates_project_number ON project_gates(project_id,gate_number);

CREATE OR REPLACE FUNCTION set_updated_at() RETURNS trigger LANGUAGE plpgsql AS $$ BEGIN NEW.updated_at=now(); RETURN NEW; END; $$;
CREATE TRIGGER projects_updated_at BEFORE UPDATE ON projects FOR EACH ROW EXECUTE FUNCTION set_updated_at();
