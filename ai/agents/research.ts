import { db } from "@/core/db";
import { createResearchRun, saveResearchResult } from "@/domain/research/service";
import { AIProvider } from "@/ai/providers/provider.interface";

export const RESEARCH_AGENTS={
 PROBLEM:{stage:"PROBLEM",mission:"Find and structure evidence for the problem, affected users, severity, frequency and existing alternatives."},
 MARKET:{stage:"MARKET",mission:"Research customer segments, market structure, demand signals, competitors and measurable market evidence."},
 TECHNOLOGY:{stage:"TECHNOLOGY",mission:"Research enabling technologies, maturity, dependencies, feasibility signals and technical alternatives."},
 REGULATION:{stage:"REGULATION",mission:"Identify applicable regulations, jurisdictions, obligations, standards and compliance questions."}
} as const;

function systemInstruction(type:keyof typeof RESEARCH_AGENTS){return `You are the PROJECT FORGE ${type} research agent. ${RESEARCH_AGENTS[type].mission} Every material claim must be traceable to a source. Do not invent sources. Return JSON with findingType,title,claim,confidence,payload,citations[]. Mark uncertain statements as pending or scenario. Human verification is required before acceptance.`}

export async function runResearchAgent(projectId:string,type:keyof typeof RESEARCH_AGENTS,query:string,provider:AIProvider){
 const run=await createResearchRun(projectId,{agentType:type,query});
 await db`UPDATE research_runs SET status='RUNNING',provider=${provider.name},started_at=now() WHERE id=${run.id}`;
 try{
  const raw=await provider.run({task:`${systemInstruction(type)}\nResearch query: ${query}`,payload:{projectId,agentType:type,query}});
  const parsed=typeof raw==='string'?JSON.parse(raw):raw;
  const result=await saveResearchResult(projectId,run.id,parsed);
  return {run,result};
 }catch(error){
  await db`UPDATE research_runs SET status='FAILED',error=${error instanceof Error?error.message:String(error)},completed_at=now() WHERE id=${run.id}`;
  throw error;
 }
}
