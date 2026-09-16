import { NextResponse } from "next/server";
import { db } from "@/core/db";
import { createResearchRun, listResearchRuns } from "@/domain/research/service";
import { researchRequestSchema } from "@/schemas/research";
import { OpenAICompatibleProvider } from "@/ai/providers/openai-compatible";
import { runResearchAgent } from "@/ai/agents/research";

type Ctx={params:Promise<{id:string}>};

export async function GET(_:Request,{params}:Ctx){try{return NextResponse.json(await listResearchRuns((await params).id))}catch(e){return NextResponse.json({error:e instanceof Error?e.message:"Database error"},{status:503})}}

export async function POST(request:Request,{params}:Ctx){
 const projectId=(await params).id;
 try{
  const input=researchRequestSchema.parse(await request.json());
  const key=process.env.AI_API_KEY;
  const model=process.env.AI_MODEL;
  const base=process.env.AI_BASE_URL||"https://api.openai.com/v1";
  if(!key||!model){return NextResponse.json({error:"AI provider not configured",required:["AI_API_KEY","AI_MODEL"]},{status:503})}
  const result=await runResearchAgent(projectId,input.agentType,input.query,new OpenAICompatibleProvider(key,model,base));
  return NextResponse.json(result,{status:201});
 }catch(e){return NextResponse.json({error:e instanceof Error?e.message:"Research failed"},{status:400})}
}
