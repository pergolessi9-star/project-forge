import { NextResponse } from "next/server";
import { buildAgentTask, discoveryAgents, type DiscoveryAgentName } from "@/ai/agents/discovery";
import { db } from "@/core/db";
import { getDiscovery } from "@/domain/discovery/service";

export async function GET(){return NextResponse.json(Object.entries(discoveryAgents).map(([name,agent])=>({name,...agent})));}

export async function POST(request:Request,{params}:{params:{id:string}}){try{const body=await request.json();const name=body.agent as DiscoveryAgentName;if(!discoveryAgents[name])return NextResponse.json({error:"Unknown discovery agent"},{status:400});const discovery=await getDiscovery(params.id);const task=buildAgentTask(name,{project:discovery.project,discovery});const run=await db`INSERT INTO ai_runs(project_id,provider,model,task,status) VALUES(${params.id},'unconfigured',NULL,${name},'QUEUED') RETURNING id,project_id,provider,model,task,status,started_at`;return NextResponse.json({run:run[0],task,nextStep:"Configure an AI provider and execute the queued task through the provider-neutral orchestrator."},{status:202});}catch(error){return NextResponse.json({error:error instanceof Error?error.message:"Agent request failed"},{status:400});}}
