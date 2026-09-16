import { NextResponse } from "next/server";
import { createProject, listProjects } from "@/domain/projects/service";
export async function GET() { return NextResponse.json(await listProjects()); }
export async function POST(request: Request) {
  try { return NextResponse.json(await createProject(await request.json()), { status: 201 }); }
  catch (error) { return NextResponse.json({ error: error instanceof Error ? error.message : "Invalid request" }, { status: 400 }); }
}
