export type DiscoveryAgentName="problem-research"|"market-research"|"technology-research"|"regulation-research";

export const discoveryAgents:Record<DiscoveryAgentName,{stage:string;task:string;requiredInputs:string[];outputType:string}>= {
 "problem-research":{stage:"PROBLEM",task:"Identify and structure the target problem, affected users, severity, current alternatives, and evidence gaps. Do not promote unsupported claims to verified evidence.",requiredInputs:["project","ideas","existing evidence"],outputType:"problem_research"},
 "market-research":{stage:"MARKET",task:"Research customer segments, market structure, competitors, demand signals, and market evidence. Separate sourced facts from estimates and scenarios.",requiredInputs:["project","problem findings","existing evidence"],outputType:"market_research"},
 "technology-research":{stage:"TECHNOLOGY",task:"Assess candidate technologies, maturity, feasibility, dependencies, risks, and technical evidence. Identify what must be validated experimentally.",requiredInputs:["project","problem findings","market findings"],outputType:"technology_research"},
 "regulation-research":{stage:"REGULATION",task:"Identify applicable regulatory domains and concrete requirements, jurisdictions, obligations, and evidence sources. Mark applicability as pending where facts are insufficient.",requiredInputs:["project","technology findings","market geography"],outputType:"regulation_research"}
};

export function buildAgentTask(name:DiscoveryAgentName,payload:unknown){const agent=discoveryAgents[name];return {agent:name,stage:agent.stage,task:agent.task,outputType:agent.outputType,payload,governance:{evidenceBoundary:["VERIFIED","DERIVED","DECLARED","SCENARIO","PENDING"],humanVerificationRequired:true}};}
