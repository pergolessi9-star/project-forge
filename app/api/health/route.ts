import { NextResponse } from "next/server";
import { db } from "@/core/db";
export async function GET() {
  try { await db`SELECT 1`; return NextResponse.json({ name:"PROJECT FORGE", version:"0.1.0", status:"ok", database:"connected" }); }
  catch { return NextResponse.json({ name:"PROJECT FORGE", version:"0.1.0", status:"degraded", database:"unavailable" }, { status: 503 }); }
}
