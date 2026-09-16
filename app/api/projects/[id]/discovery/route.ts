import { NextResponse } from "next/server";
import { addEntity, addEvidence, addSource, getDiscovery } from "@/domain/discovery/service";

export async function GET(_request:Request,{params}:{params:{id:string}}){try{return NextResponse.json(await getDiscovery(params.id));}catch(error){return NextResponse.json({error:error instanceof Error?error.message:"Discovery error"},{status:503});}}

export async function POST(request:Request,{params}:{params:{id:string}}){try{const body=await request.json();if(body.type==="evidence")return NextResponse.json(await addEvidence(params.id,body.data),{status:201});if(body.type==="source")return NextResponse.json(await addSource(params.id,body.data),{status:201});if(["problem","customer","market","competitor","technology","regulation"].includes(body.type))return NextResponse.json(await addEntity(params.id,body.type,body.data),{status:201});return NextResponse.json({error:"Unknown discovery entity type"},{status:400});}catch(error){return NextResponse.json({error:error instanceof Error?error.message:"Invalid request"},{status:400});}}
