import { NextResponse } from "next/server";
import { db } from "@/core/db";

type Ctx={params:Promise<{id:string}>};
const gates=[
 {number:0,stage:"INTAKE",label:"Intake"},{number:1,stage:"PROBLEM",label:"Problem evidence"},{number:2,stage:"MARKET",label:"Market evidence"},
 {number:3,stage:"TECHNOLOGY",label:"Technology feasibility"},{number:4,stage:"REGULATION",label:"Regulatory feasibility"},{number:5,stage:"CONCEPT",label:"Concept"},
 {number:6,stage:"MVP",label:"MVP"},{number:7,stage:"VALIDATION",label:"Validation"},{number:8,stage:"SPECIFICATION",label:"Specification"}
];
export async function GET(_:Request,{params}:Ctx){
 try{
  const projectId=(await params).id;
  const p=await db`SELECT id,current_stage,status FROM projects WHERE id=${projectId}`; if(!p[0]) return NextResponse.json({error:"Project not found"},{status:404});
  const [e,g]=await Promise.all([db`SELECT status,COUNT(*)::int AS count FROM evidence WHERE project_id=${projectId} GROUP BY status`,db`SELECT * FROM project_gates WHERE project_id=${projectId} ORDER BY gate_number`]);
  const verified=e.filter((x:any)=>x.status==='VERIFIED').reduce((n:number,x:any)=>n+x.count,0);
  const pending=e.filter((x:any)=>x.status!=='VERIFIED').reduce((n:number,x:any)=>n+x.count,0);
  return NextResponse.json({project:p[0],evidence:{verified,pending,byStatus:e},gates:g.map((x:any)=>({...x,ready:x.status==='ADVANCE'||(x.status==='READY'&&verified>0)})),sequence:gates});
 }catch(e){return NextResponse.json({error:e instanceof Error?e.message:"Readiness failed"},{status:503})}
}
