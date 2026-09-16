import { db } from "@/core/db";
import { projectSchema } from "@/schemas/project";

export async function listProjects() {
  return db`SELECT * FROM projects ORDER BY updated_at DESC`;
}

export async function createProject(input: unknown) {
  const data = projectSchema.parse(input);
  const rows = await db`
    INSERT INTO projects (code, name, description, status, current_stage)
    VALUES (${data.projectCode}, ${data.name}, ${data.description ?? null}, ${data.status}, ${data.currentStage})
    RETURNING *
  `;
  return rows[0];
}
