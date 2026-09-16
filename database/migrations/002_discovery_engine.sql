-- PROJECT FORGE v0.1 Discovery Engine
-- SQL remains the canonical data contract.

ALTER TABLE problems ADD CONSTRAINT problems_severity_range CHECK (severity IS NULL OR severity BETWEEN 1 AND 5);
ALTER TABLE technology_assessments ADD CONSTRAINT technology_assessment_feasibility_range CHECK (feasibility IS NULL OR feasibility BETWEEN 0 AND 100);
ALTER TABLE technology_assessments ADD CONSTRAINT technology_assessment_readiness_range CHECK (readiness IS NULL OR readiness BETWEEN 0 AND 100);
ALTER TABLE evidence ADD CONSTRAINT evidence_confidence_range CHECK (confidence IS NULL OR confidence BETWEEN 0 AND 100);
ALTER TABLE scientific_claims ADD CONSTRAINT scientific_claims_confidence_range CHECK (confidence IS NULL OR confidence BETWEEN 0 AND 100);
ALTER TABLE evidence_verifications ADD CONSTRAINT evidence_verification_decision CHECK (decision IN ('ACCEPT','REJECT','REQUEST_CHANGES'));
ALTER TABLE human_reviews ADD CONSTRAINT human_review_decision CHECK (decision IN ('ACCEPT','REJECT','REQUEST_CHANGES'));

CREATE INDEX IF NOT EXISTS idx_problems_project ON problems(project_id);
CREATE INDEX IF NOT EXISTS idx_customers_project ON customers(project_id);
CREATE INDEX IF NOT EXISTS idx_markets_project ON markets(project_id);
CREATE INDEX IF NOT EXISTS idx_competitors_project ON competitors(project_id);
CREATE INDEX IF NOT EXISTS idx_technologies_project ON technologies(project_id);
CREATE INDEX IF NOT EXISTS idx_regulations_project ON regulations(project_id);
CREATE INDEX IF NOT EXISTS idx_claims_project ON scientific_claims(project_id);
CREATE INDEX IF NOT EXISTS idx_sources_project ON evidence_sources(project_id);
CREATE INDEX IF NOT EXISTS idx_reviews_project ON human_reviews(project_id,reviewed_at DESC);

-- Ensure the canonical nine gates exist for projects created after this migration.
CREATE OR REPLACE FUNCTION initialize_project_gates() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO project_gates(project_id,gate_number,gate_code,stage)
  VALUES
    (NEW.id,0,'INTAKE','INTAKE'),
    (NEW.id,1,'PROBLEM_EVIDENCE','PROBLEM'),
    (NEW.id,2,'MARKET_EVIDENCE','MARKET'),
    (NEW.id,3,'TECHNOLOGY_FEASIBILITY','TECHNOLOGY'),
    (NEW.id,4,'REGULATORY_FEASIBILITY','REGULATION'),
    (NEW.id,5,'CONCEPT','CONCEPT'),
    (NEW.id,6,'MVP','MVP'),
    (NEW.id,7,'VALIDATION','VALIDATION'),
    (NEW.id,8,'SPECIFICATION','SPECIFICATION');
  RETURN NEW;
END;
$$;
CREATE TRIGGER projects_initialize_gates AFTER INSERT ON projects FOR EACH ROW EXECUTE FUNCTION initialize_project_gates();

-- Backfill gates for projects that existed before the trigger.
INSERT INTO project_gates(project_id,gate_number,gate_code,stage)
SELECT p.id,g.gate_number,g.gate_code,g.stage
FROM projects p
CROSS JOIN (VALUES
  (0,'INTAKE','INTAKE'::project_stage),(1,'PROBLEM_EVIDENCE','PROBLEM'::project_stage),(2,'MARKET_EVIDENCE','MARKET'::project_stage),(3,'TECHNOLOGY_FEASIBILITY','TECHNOLOGY'::project_stage),(4,'REGULATORY_FEASIBILITY','REGULATION'::project_stage),(5,'CONCEPT','CONCEPT'::project_stage),(6,'MVP','MVP'::project_stage),(7,'VALIDATION','VALIDATION'::project_stage),(8,'SPECIFICATION','SPECIFICATION'::project_stage)
) g(gate_number,gate_code,stage)
WHERE NOT EXISTS (SELECT 1 FROM project_gates pg WHERE pg.project_id=p.id AND pg.gate_number=g.gate_number);
