import { NextResponse } from "next/server";
import { db } from "@/core/db";
import { evidenceSchema } from "@/schemas/evidence";
export async function GET(){return NextResponse.json(await db`SELECT * FROM evidence ORDER BY created_at DESC`)}
export async function POST(request:Request){try{const data=evidenceSchema.parse(await request.json());const rows=await db`INSERT INTO evidence(project_id,source_id,claim,status,confidence,excerpt,locator) VALUES(${data.projectId},${data.sourceId??null},${data.claim},${data.status},${data.confidence??null},${data.excerpt??null},${data.locator??null}) RETURNING *`;return NextResponse.json(rows[0],{status:201})}catch(error){return NextResponse.json({error:error instanceof Error?error.message:"Invalid request"},{status:400})}}
