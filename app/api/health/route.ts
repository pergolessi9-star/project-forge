import { NextResponse } from "next/server";
import { db } from "@/core/db";
export async function GET(){try{const [{now}]=await db`SELECT now()`;return NextResponse.json({name:"PROJECT FORGE",version:"0.1.0",status:"ok",database:"connected",time:now})}catch(error){return NextResponse.json({name:"PROJECT FORGE",version:"0.1.0",status:"degraded",database:"disconnected",error:error instanceof Error?error.message:"Database error"},{status:503})}}
