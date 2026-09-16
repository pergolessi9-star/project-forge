INSERT INTO projects (project_code, name, slug, description, status, current_stage)
VALUES (
  'PF-0001',
  'Project Forge Demonstrator',
  'project-forge-demonstrator',
  'Seed project demonstrating the evidence-first discovery workflow.',
  'DISCOVERY',
  'EVIDENCE'
);

INSERT INTO project_ideas (project_id, title, description, origin, hypothesis)
SELECT id,
  'Evidence-first discovery platform',
  'A platform that transforms early project ideas into evidence-backed concepts before engineering begins.',
  'SYSTEM_DESIGN',
  'Structured discovery and human verification can reduce premature product engineering.'
FROM projects WHERE project_code = 'PF-0001';

INSERT INTO project_gates (project_id, gate_number, gate_type, status)
SELECT id, n, t, CASE WHEN n = 1 THEN 'READY' ELSE 'PENDING' END
FROM projects,
LATERAL (VALUES
  (0,'INTAKE'),
  (1,'PROBLEM_EVIDENCE'),
  (2,'MARKET_EVIDENCE'),
  (3,'TECHNOLOGY_FEASIBILITY'),
  (4,'REGULATORY_FEASIBILITY'),
  (5,'CONCEPT'),
  (6,'MVP'),
  (7,'VALIDATION'),
  (8,'SPECIFICATION')
) AS gates(n,t)
WHERE project_code = 'PF-0001';

INSERT INTO evidence_sources (project_id, source_type, title, publisher)
SELECT id, 'INTERNAL', 'PROJECT FORGE foundation specification', 'PROJECT FORGE'
FROM projects WHERE project_code = 'PF-0001';

INSERT INTO evidence (project_id, evidence_code, claim, evidence_type, confidence, status, source_id)
SELECT p.id, 'EV-0001',
  'PROJECT FORGE separates discovery from engineering and requires evidence and human verification before product handoff.',
  'DECLARED', 'HIGH', 'PENDING', s.id
FROM projects p
JOIN evidence_sources s ON s.project_id = p.id
WHERE p.project_code = 'PF-0001';
