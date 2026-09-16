import { db } from "@/core/db";
import { projectCreateSchema, projectUpdateSchema } from "@/schemas/project";

const gates = [
  [0, "INTAKE", "INTAKE"],
  [1, "PROBLEM_EVIDENCE", "PROBLEM"],
  [2, "MARKET_EVIDENCE", "MARKET"],
  [3, "TECHNOLOGY_FEASIBILITY", "TECHNOLOGY"],
  [4, "REGULATORY_FEASIBILITY", "REGULATION"],
  [5, "CONCEPT", "CONCEPT"],
  [6, "MVP", "MVP"],
  [7, "VALIDATION", "VALIDATION"],
  [8, "SPECIFICATION", "SPECIFICATION"],
] as const;

export async function listProjects() {
  return db`SELECT p.*, COUNT(e.id)::int AS evidence_count FROM projects p LEFT JOIN evidence e ON e.project_id=p.id GROUP BY p.id ORDER BY p.updated_at DESC`;
}
export async function getProject(id: string) {
  const rows = await db`SELECT * FROM projects WHERE id = ${id}::uuid LIMIT 1`;
  return rows[0] ?? null;
}
export async function createProject(input: unknown) {
  const data = projectCreateSchema.parse(input);
  const rows = await db`INSERT INTO projects (code,name,description,status,current_stage,owner,confidence) VALUES (${data.code},${data.name},${data.description ?? null},${data.status},${data.currentStage},${data.owner ?? null},${data.confidence ?? null}) RETURNING *`;
  const project = rows[0];
  for (const [gateNumber, gateCode, stage] of gates) {
    await db`INSERT INTO project_gates(project_id,gate_number,gate_code,stage,status) VALUES(${project.id},${gateNumber},${gateCode},${stage},${gateNumber === 0 ? "READY" : "PENDING"}) ON CONFLICT(project_id,gate_number) DO NOTHING`;
  }
  await db`INSERT INTO audit_trail(project_id,actor,action,entity_type,entity_id,payload) VALUES(${project.id},'system','PROJECT_CREATED','project',${project.id},${JSON.stringify({code:data.code})})`;
  return project;
}
export async function updateProject(id: string, input: unknown) {
  const data = projectUpdateSchema.parse(input);
  const rows = await db`UPDATE projects SET name=COALESCE(${data.name ?? null},name), description=COALESCE(${data.description ?? null},description), status=COALESCE(${data.status ?? null},status), current_stage=COALESCE(${data.currentStage ?? null},current_stage), owner=COALESCE(${data.owner ?? null},owner), confidence=COALESCE(${data.confidence ?? null},confidence), updated_at=now() WHERE id=${id}::uuid RETURNING *`;
  return rows[0] ?? null;
}
export async function deleteProject(id: string) {
  const rows = await db`DELETE FROM projects WHERE id=${id}::uuid RETURNING id`;
  return rows[0] ?? null;
}
