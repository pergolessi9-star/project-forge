import { db } from "@/core/db";
import { researchRequestSchema, researchFindingSchema } from "@/schemas/research";

export async function createResearchRun(projectId:string,input:unknown){
 const d=researchRequestSchema.parse(input);
 const p=await db`SELECT id,code,name,description,current_stage FROM projects WHERE id=${projectId}`;
 if(!p[0]) throw new Error("Project not found");
 const r=await db`INSERT INTO research_runs(project_id,agent_type,query,status) VALUES(${projectId},${d.agentType},${d.query},'QUEUED') RETURNING *`;
 return r[0];
}
export async function listResearchRuns(projectId:string){
 return db`SELECT r.*,COALESCE(json_agg(f ORDER BY f.created_at DESC) FILTER (WHERE f.id IS NOT NULL),'[]'::json) AS findings FROM research_runs r LEFT JOIN research_findings f ON f.research_run_id=r.id WHERE r.project_id=${projectId} GROUP BY r.id ORDER BY r.created_at DESC`;
}
export async function saveResearchResult(projectId:string,runId:string,input:unknown){
 const d=researchFindingSchema.parse(input);
 const run=await db`SELECT id FROM research_runs WHERE id=${runId} AND project_id=${projectId}`;
 if(!run[0]) throw new Error("Research run not found");
 const f=await db`INSERT INTO research_findings(research_run_id,project_id,finding_type,title,claim,confidence,payload) VALUES(${runId},${projectId},${d.findingType},${d.title},${d.claim},${d.confidence??null},${JSON.stringify(d.payload)}) RETURNING *`;
 for(const c of d.citations){
   let sourceId:string|null=null;
   if(c.url){const s=await db`SELECT id FROM evidence_sources WHERE project_id=${projectId} AND source_url=${c.url} LIMIT 1`;sourceId=s[0]?.id??null;
     if(!sourceId){const created=await db`INSERT INTO evidence_sources(project_id,title,source_type,source_url,retrieved_at) VALUES(${projectId},${c.url},'RESEARCH',${c.url},now()) RETURNING id`;sourceId=created[0].id;}
   }
   await db`INSERT INTO research_citations(finding_id,source_id,url,locator,excerpt) VALUES(${f[0].id},${sourceId},${c.url??null},${c.locator??null},${c.excerpt??null})`;
 }
 await db`UPDATE research_runs SET status='COMPLETED',completed_at=now() WHERE id=${runId}`;
 await db`INSERT INTO audit_trail(project_id,actor,action,entity_type,entity_id,payload) VALUES(${projectId},'research-agent','RESEARCH_COMPLETED','research_run',${runId},${JSON.stringify({agentType:d.findingType,title:d.title})})`;
 return f[0];
}
