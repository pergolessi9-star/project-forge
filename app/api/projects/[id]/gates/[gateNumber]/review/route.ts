import { NextResponse } from "next/server";
import { reviewGate } from "@/domain/discovery/service";
export async function POST(request:Request,{params}:{params:{id:string;gateNumber:string}}){try{const n=Number(params.gateNumber);if(!Number.isInteger(n)||n<0||n>8)return NextResponse.json({error:"Invalid gate number"},{status:400});return NextResponse.json(await reviewGate(params.id,n,await request.json()));}catch(error){return NextResponse.json({error:error instanceof Error?error.message:"Gate review failed"},{status:400});}}
