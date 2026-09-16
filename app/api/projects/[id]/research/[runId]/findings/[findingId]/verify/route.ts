import { NextResponse } from "next/server";
import { db } from "@/core/db";
import { humanVerificationSchema } from "@/schemas/discovery";

type Ctx={params:Promise<{id:string;runId:string;findingId:string}>};

export async function POST(request:Request,{params}:Ctx){
 const {id:projectId,runId,findingId}=await params;
 try{
  const d=humanVerificationSchema.parse(await request.json());
  const rows=await db`SELECT f.*,r.agent_type FROM research_findings f JOIN research_runs r ON r.id=f.research_run_id WHERE f.id=${findingId} AND f.project_id=${projectId} AND f.research_run_id=${runId}`;
  if(!rows[0]) throw new Error("Research finding not found");
  const finding=rows[0];
  const evidence=await db`INSERT INTO evidence(project_id,claim,status,confidence,excerpt,locator) VALUES(${projectId},${finding.claim},${d.decision==='ACCEPT'?'VERIFIED':'PENDING'},${finding.confidence??null},${finding.payload?.excerpt??null},${finding.payload?.locator??null}) RETURNING *`;
  await db`INSERT INTO evidence_verifications(evidence_id,reviewer,decision,rationale) VALUES(${evidence[0].id},${d.reviewer},${d.decision},${d.rationale??null})`;
  await db`INSERT INTO human_reviews(project_id,target_type,target_id,reviewer,decision,rationale) VALUES(${projectId},'RESEARCH_FINDING',${findingId},${d.reviewer},${d.decision},${d.rationale??null})`;
  await db`UPDATE research_findings SET evidence_status=${d.decision==='ACCEPT'?'VERIFIED':'PENDING'} WHERE id=${findingId}`;
  await db`INSERT INTO audit_trail(project_id,actor,action,entity_type,entity_id,payload) VALUES(${projectId},${d.reviewer},'RESEARCH_FINDING_VERIFIED','research_finding',${findingId},${JSON.stringify({decision:d.decision,evidenceId:evidence[0].id})})`;
  return NextResponse.json({findingId,evidence:evidence[0],decision:d.decision},{status:201});
 }catch(e){return NextResponse.json({error:e instanceof Error?e.message:"Verification failed"},{status:400})}
}
