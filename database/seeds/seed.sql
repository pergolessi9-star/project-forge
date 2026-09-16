INSERT INTO projects (code, name, description, status, current_stage)
VALUES ('PF-0001','Project Forge Demonstrator','Seed project demonstrating the evidence-first discovery workflow.','DISCOVERY','EVIDENCE');

INSERT INTO project_ideas (project_id, statement)
SELECT id,'A platform that transforms early project ideas into evidence-backed concepts before engineering begins.'
FROM projects WHERE code='PF-0001';

INSERT INTO project_gates (project_id, gate_number, gate_code, stage, status)
SELECT id,n,t,s,CASE WHEN n=1 THEN 'READY' ELSE 'PENDING' END
FROM projects,
LATERAL (VALUES
 (0,'INTAKE','INTAKE'),(1,'PROBLEM_EVIDENCE','PROBLEM'),(2,'MARKET_EVIDENCE','MARKET'),
 (3,'TECHNOLOGY_FEASIBILITY','TECHNOLOGY'),(4,'REGULATORY_FEASIBILITY','REGULATION'),
 (5,'CONCEPT','CONCEPT'),(6,'MVP','MVP'),(7,'VALIDATION','VALIDATION'),(8,'SPECIFICATION','SPECIFICATION')
) AS gates(n,t,s)
WHERE code='PF-0001';

INSERT INTO evidence_sources (project_id, title, source_type, publisher)
SELECT id,'PROJECT FORGE foundation specification','INTERNAL','PROJECT FORGE'
FROM projects WHERE code='PF-0001';

INSERT INTO evidence (project_id, claim, status, confidence, source_id)
SELECT p.id,'PROJECT FORGE separates discovery from engineering and requires evidence and human verification before product handoff.','DECLARED',0.90,s.id
FROM projects p JOIN evidence_sources s ON s.project_id=p.id
WHERE p.code='PF-0001';
