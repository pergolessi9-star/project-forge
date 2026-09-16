import { db } from "@/core/db";
import { problemSchema, customerSchema, marketSchema, competitorSchema, technologySchema, regulationSchema, evidenceSourceSchema, evidenceSchema, humanVerificationSchema, gateReviewSchema } from "@/schemas/discovery";

const schemas={problem:problemSchema,customer:customerSchema,market:marketSchema,competitor:competitorSchema,technology:technologySchema,regulation:regulationSchema};
const tables={problem:"problems",customer:"customers",market:"markets",competitor:"competitors",technology:"technologies",regulation:"regulations"};

export async function getDiscovery(projectId:string){
 const [project,problem,customer,market,competitor,technology,regulation,sources,evidence,reviews,gates]=await Promise.all([
  db`SELECT * FROM projects WHERE id=${projectId}`,
  db`SELECT * FROM problems WHERE project_id=${projectId}`,
  db`SELECT * FROM customers WHERE project_id=${projectId}`,
  db`SELECT * FROM markets WHERE project_id=${projectId}`,
  db`SELECT * FROM competitors WHERE project_id=${projectId}`,
  db`SELECT * FROM technologies WHERE project_id=${projectId}`,
  db`SELECT * FROM regulations WHERE project_id=${projectId}`,
  db`SELECT * FROM evidence_sources WHERE project_id=${projectId} ORDER BY created_at DESC`,
  db`SELECT * FROM evidence WHERE project_id=${projectId} ORDER BY created_at DESC`,
  db`SELECT * FROM human_reviews WHERE project_id=${projectId} ORDER BY reviewed_at DESC`,
  db`SELECT * FROM project_gates WHERE project_id=${projectId} ORDER BY gate_number`
 ]);
 return {project:project[0]??null,problem,customer,market,competitor,technology,regulation,sources,evidence,reviews,gates};
}

export async function addEntity(projectId:string,type:keyof typeof tables,input:unknown){
 const d=schemas[type].parse(input) as Record<string,unknown>;
 const map:any={problem:["statement","severity","evidence_status"],customer:["name","segment","need","evidence_status"],market:["name","geography","tam","sam","som","growth_rate","evidence_status"],competitor:["name","url","positioning","strengths","weaknesses","evidence_status"],technology:["name","maturity","description","evidence_status"],regulation:["name","jurisdiction","applicability","evidence_status"]};
 const cols=map[type]; const vals=cols.map((c:string)=>d[c.replace(/_([a-z])/g,(_:string,x:string)=>x.toUpperCase())]);
 const placeholders=vals.map((_:unknown,i:number)=>`$${i+2}`).join(",");
 const result=await db.unsafe(`INSERT INTO ${tables[type]} (project_id,${cols.join(",")}) VALUES ($1,${placeholders}) RETURNING *`,[projectId,...vals]);
 return result[0];
}

export async function addSource(projectId:string,input:unknown){const d=evidenceSourceSchema.parse(input);const r=await db`INSERT INTO evidence_sources(project_id,title,source_type,source_url,publisher,metadata) VALUES(${projectId},${d.title},${d.sourceType??null},${d.sourceUrl??null},${d.publisher??null},${d.metadata?JSON.stringify(d.metadata):null}) RETURNING *`;return r[0];}
export async function addEvidence(projectId:string,input:unknown){const d=evidenceSchema.parse(input);const r=await db`INSERT INTO evidence(project_id,source_id,claim,status,confidence,excerpt,locator) VALUES(${projectId},${d.sourceId??null},${d.claim},${d.status},${d.confidence??null},${d.excerpt??null},${d.locator??null}) RETURNING *`;return r[0];}
export async function verifyEvidence(projectId:string,evidenceId:string,input:unknown){const d=humanVerificationSchema.parse(input);const e=await db`SELECT id FROM evidence WHERE id=${evidenceId} AND project_id=${projectId}`;if(!e[0])throw new Error("Evidence not found");const r=await db`INSERT INTO evidence_verifications(evidence_id,reviewer,decision,rationale) VALUES(${evidenceId},${d.reviewer},${d.decision},${d.rationale??null}) RETURNING *`;if(d.decision==="ACCEPT")await db`UPDATE evidence SET status='VERIFIED' WHERE id=${evidenceId}`;await db`INSERT INTO human_reviews(project_id,target_type,target_id,reviewer,decision,rationale) VALUES(${projectId},'EVIDENCE',${evidenceId},${d.reviewer},${d.decision},${d.rationale??null})`;return r[0];}
export async function reviewGate(projectId:string,gateNumber:number,input:unknown){const d=gateReviewSchema.parse(input);const g=await db`SELECT * FROM project_gates WHERE project_id=${projectId} AND gate_number=${gateNumber}`;if(!g[0])throw new Error("Gate not found");const r=await db`INSERT INTO gate_reviews(gate_id,reviewer,status,rationale) VALUES(${g[0].id},${d.reviewer},${d.status},${d.rationale??null}) RETURNING *`;await db`UPDATE project_gates SET status=${d.status} WHERE id=${g[0].id}`;return r[0];}
