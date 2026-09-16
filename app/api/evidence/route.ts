import { NextResponse } from "next/server";
import { db } from "@/core/db";
export async function GET() { return NextResponse.json(await db`SELECT * FROM evidence ORDER BY created_at DESC`); }
