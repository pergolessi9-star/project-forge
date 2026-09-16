import { NextResponse } from "next/server";
import { verifyEvidence } from "@/domain/discovery/service";
export async function POST(request:Request,{params}:{params:{id:string;evidenceId:string}}){try{return NextResponse.json(await verifyEvidence(params.id,params.evidenceId,await request.json()));}catch(error){return NextResponse.json({error:error instanceof Error?error.message:"Verification failed"},{status:400});}}
