import { NextResponse } from "next/server";
import { db } from "@/core/db";
import { projectSchema } from "@/schemas/project";

export async function GET(_: Request, { params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  const rows = await db`SELECT * FROM projects WHERE id=${id} LIMIT 1`;
  if (!rows[0]) return NextResponse.json({ error: "Project not found" }, { status: 404 });
  return NextResponse.json(rows[0]);
}

export async function PATCH(request: Request, { params }: { params: Promise<{ id: string }> }) {
  try {
    const { id } = await params;
    const data = projectSchema.partial().parse(await request.json());
    const rows = await db`
      UPDATE projects SET
        code=COALESCE(${data.projectCode ?? null}, code),
        name=COALESCE(${data.name ?? null}, name),
        description=COALESCE(${data.description ?? null}, description),
        status=COALESCE(${data.status ?? null}, status),
        current_stage=COALESCE(${data.currentStage ?? null}, current_stage),
        updated_at=now()
      WHERE id=${id} RETURNING *`;
    if (!rows[0]) return NextResponse.json({ error: "Project not found" }, { status: 404 });
    return NextResponse.json(rows[0]);
  } catch (error) { return NextResponse.json({ error: error instanceof Error ? error.message : "Invalid request" }, { status: 400 }); }
}

export async function DELETE(_: Request, { params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  const rows = await db`DELETE FROM projects WHERE id=${id} RETURNING id`;
  if (!rows[0]) return NextResponse.json({ error: "Project not found" }, { status: 404 });
  return NextResponse.json({ deleted: true, id });
}
