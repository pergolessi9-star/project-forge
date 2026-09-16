CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE projects (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_code VARCHAR(50) UNIQUE NOT NULL,
  name VARCHAR(255) NOT NULL,
  slug VARCHAR(255) UNIQUE NOT NULL,
  description TEXT,
  status VARCHAR(40) NOT NULL DEFAULT 'IDEA',
  current_stage VARCHAR(40) NOT NULL DEFAULT 'INTAKE',
  owner_id UUID,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE project_versions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  version INTEGER NOT NULL,
  snapshot JSONB NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(project_id, version)
);

CREATE TABLE project_ideas (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  origin VARCHAR(50),
  hypothesis TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE problems (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  affected_population TEXT,
  frequency TEXT,
  severity TEXT,
  economic_impact NUMERIC,
  evidence_status VARCHAR(30) DEFAULT 'PENDING',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE customers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  customer_type VARCHAR(100),
  sector VARCHAR(150),
  geography VARCHAR(150),
  buyer_role VARCHAR(150),
  user_role VARCHAR(150),
  needs TEXT,
  willingness_to_pay TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE markets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  market_name VARCHAR(255),
  geography VARCHAR(150),
  tam NUMERIC,
  sam NUMERIC,
  som NUMERIC,
  currency VARCHAR(10),
  growth_rate NUMERIC,
  assumptions JSONB,
  sources JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE competitors (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  website TEXT,
  product TEXT,
  target_customer TEXT,
  pricing TEXT,
  technology TEXT,
  strengths TEXT,
  weaknesses TEXT,
  source_evidence JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE technologies (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  category VARCHAR(150),
  description TEXT,
  maturity VARCHAR(50),
  trl INTEGER CHECK (trl IS NULL OR (trl BETWEEN 1 AND 9)),
  open_source BOOLEAN,
  license VARCHAR(150),
  dependencies JSONB,
  vendors JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE technology_assessments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  technology_id UUID REFERENCES technologies(id) ON DELETE SET NULL,
  feasibility TEXT,
  scalability TEXT,
  interoperability TEXT,
  security TEXT,
  sovereignty TEXT,
  assessment_status VARCHAR(30) DEFAULT 'PENDING',
  evidence_id UUID,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE regulations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  jurisdiction VARCHAR(100),
  type VARCHAR(100),
  reference VARCHAR(255),
  source_url TEXT,
  description TEXT,
  applicability VARCHAR(30) DEFAULT 'UNKNOWN',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE regulatory_requirements (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  regulation_id UUID NOT NULL REFERENCES regulations(id) ON DELETE CASCADE,
  requirement TEXT NOT NULL,
  applicability TEXT,
  implementation_requirement TEXT,
  evidence_required TEXT,
  status VARCHAR(40) DEFAULT 'PENDING',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE scientific_claims (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  claim TEXT NOT NULL,
  scientific_basis TEXT,
  publication_reference TEXT,
  doi TEXT,
  confidence VARCHAR(30),
  verification_status VARCHAR(30) DEFAULT 'PENDING',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE research_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  source_type VARCHAR(100),
  source_url TEXT,
  authors TEXT,
  publication_date DATE,
  abstract TEXT,
  extracted_content TEXT,
  metadata JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE evidence_sources (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  source_type VARCHAR(100),
  title TEXT,
  publisher TEXT,
  url TEXT,
  document_hash VARCHAR(128),
  publication_date DATE,
  retrieved_at TIMESTAMPTZ,
  metadata JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE evidence (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  evidence_code VARCHAR(50) NOT NULL,
  claim TEXT NOT NULL,
  evidence_type VARCHAR(40) NOT NULL CHECK (evidence_type IN ('VERIFIED','DERIVED','DECLARED','SCENARIO','PENDING')),
  confidence VARCHAR(30),
  status VARCHAR(30) NOT NULL DEFAULT 'PENDING',
  source_id UUID REFERENCES evidence_sources(id) ON DELETE SET NULL,
  extracted_text TEXT,
  structured_data JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(project_id, evidence_code)
);

CREATE TABLE evidence_verifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  evidence_id UUID NOT NULL REFERENCES evidence(id) ON DELETE CASCADE,
  verifier_id UUID,
  verification_status VARCHAR(30) NOT NULL,
  notes TEXT,
  verified_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE funding_programmes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  programme VARCHAR(150),
  jurisdiction VARCHAR(100),
  description TEXT,
  source_url TEXT,
  metadata JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE funding_opportunities (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  programme_id UUID REFERENCES funding_programmes(id) ON DELETE SET NULL,
  call_name VARCHAR(255),
  deadline DATE,
  funding_type VARCHAR(100),
  eligible_actions TEXT,
  fit_description TEXT,
  evidence_id UUID REFERENCES evidence(id) ON DELETE SET NULL,
  status VARCHAR(40) DEFAULT 'PENDING',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE project_concepts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  version INTEGER NOT NULL,
  value_proposition TEXT,
  proposed_solution TEXT,
  novelty TEXT,
  target_customer TEXT,
  technology_summary TEXT,
  regulatory_summary TEXT,
  market_summary TEXT,
  business_model TEXT,
  funding_strategy TEXT,
  ip_strategy TEXT,
  sovereignty_strategy TEXT,
  open_questions JSONB,
  generated_by VARCHAR(100),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE mvp_definitions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  name VARCHAR(255),
  hypothesis TEXT,
  scope TEXT,
  excluded_scope TEXT,
  required_components JSONB,
  success_criteria JSONB,
  estimated_effort TEXT,
  dependencies JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE validation_experiments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  mvp_id UUID REFERENCES mvp_definitions(id) ON DELETE SET NULL,
  name VARCHAR(255) NOT NULL,
  hypothesis TEXT NOT NULL,
  method TEXT,
  target_users TEXT,
  metrics JSONB,
  success_criteria JSONB,
  status VARCHAR(40) DEFAULT 'PLANNED',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE validation_results (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  experiment_id UUID NOT NULL REFERENCES validation_experiments(id) ON DELETE CASCADE,
  result_summary TEXT,
  metrics JSONB,
  observations TEXT,
  user_feedback TEXT,
  conclusion TEXT,
  evidence_id UUID REFERENCES evidence(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE project_risks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  category VARCHAR(100),
  description TEXT NOT NULL,
  likelihood VARCHAR(30),
  impact VARCHAR(30),
  mitigation TEXT,
  status VARCHAR(40) DEFAULT 'OPEN',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE ip_assets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  asset_type VARCHAR(100),
  description TEXT,
  ownership_status VARCHAR(50),
  protection_strategy TEXT,
  prior_art TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE sovereignty_assessments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  dependency TEXT,
  provider TEXT,
  jurisdiction TEXT,
  criticality VARCHAR(30),
  alternative TEXT,
  mitigation TEXT,
  status VARCHAR(40) DEFAULT 'PENDING',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE open_questions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  question TEXT NOT NULL,
  category VARCHAR(100),
  priority VARCHAR(30),
  status VARCHAR(30) DEFAULT 'OPEN',
  answer TEXT,
  resolved_at TIMESTAMPTZ
);

CREATE TABLE decisions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  question TEXT NOT NULL,
  options JSONB,
  decision TEXT,
  rationale TEXT,
  decision_owner UUID,
  reversibility VARCHAR(30),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE decision_evidence (
  decision_id UUID NOT NULL REFERENCES decisions(id) ON DELETE CASCADE,
  evidence_id UUID NOT NULL REFERENCES evidence(id) ON DELETE CASCADE,
  PRIMARY KEY(decision_id, evidence_id)
);

CREATE TABLE project_gates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  gate_number INTEGER NOT NULL,
  gate_type VARCHAR(60) NOT NULL,
  status VARCHAR(30) NOT NULL DEFAULT 'PENDING',
  requirements JSONB,
  completed_at TIMESTAMPTZ,
  UNIQUE(project_id, gate_number)
);

CREATE TABLE gate_reviews (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  gate_id UUID NOT NULL REFERENCES project_gates(id) ON DELETE CASCADE,
  reviewer_id UUID,
  decision VARCHAR(30),
  findings TEXT,
  evidence_ids JSONB,
  reviewed_at TIMESTAMPTZ
);

CREATE TABLE ai_runs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
  provider VARCHAR(100),
  model VARCHAR(150),
  task_type VARCHAR(100),
  prompt_version VARCHAR(50),
  input_hash VARCHAR(128),
  status VARCHAR(40),
  started_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  metadata JSONB
);

CREATE TABLE ai_outputs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ai_run_id UUID NOT NULL REFERENCES ai_runs(id) ON DELETE CASCADE,
  output_type VARCHAR(100),
  content JSONB,
  confidence VARCHAR(30),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE ai_sources (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ai_run_id UUID NOT NULL REFERENCES ai_runs(id) ON DELETE CASCADE,
  source_type VARCHAR(100),
  source_reference TEXT,
  relevance NUMERIC,
  metadata JSONB
);

CREATE TABLE human_reviews (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  object_type VARCHAR(100),
  object_id UUID,
  reviewer_id UUID,
  decision VARCHAR(50),
  comments TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE audit_trail (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
  actor_type VARCHAR(50),
  actor_id UUID,
  action VARCHAR(100) NOT NULL,
  entity_type VARCHAR(100),
  entity_id UUID,
  before_state JSONB,
  after_state JSONB,
  metadata JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_projects_status ON projects(status);
CREATE INDEX idx_projects_stage ON projects(current_stage);
CREATE INDEX idx_evidence_project ON evidence(project_id);
CREATE INDEX idx_evidence_status ON evidence(status);
CREATE INDEX idx_evidence_type ON evidence(evidence_type);
CREATE INDEX idx_research_project ON research_items(project_id);
CREATE INDEX idx_markets_project ON markets(project_id);
CREATE INDEX idx_technologies_project ON technologies(project_id);
CREATE INDEX idx_regulations_project ON regulations(project_id);
CREATE INDEX idx_gates_project ON project_gates(project_id);
CREATE INDEX idx_audit_project_created ON audit_trail(project_id, created_at DESC);
CREATE INDEX idx_ai_runs_project ON ai_runs(project_id);
