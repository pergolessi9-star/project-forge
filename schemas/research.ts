import { z } from "zod";

export const researchAgentTypeSchema=z.enum(["PROBLEM","MARKET","TECHNOLOGY","REGULATION","SYNTHESIS"]);
export const researchRunStatusSchema=z.enum(["QUEUED","RUNNING","COMPLETED","FAILED","REVIEW_REQUIRED"]);
export const researchRequestSchema=z.object({agentType:researchAgentTypeSchema,query:z.string().trim().min(3).max(2000)});
export const researchCitationSchema=z.object({url:z.string().url().optional(),locator:z.string().max(500).optional(),excerpt:z.string().max(10000).optional()});
export const researchFindingSchema=z.object({findingType:z.string().min(1).max(100),title:z.string().min(1).max(500),claim:z.string().min(1).max(10000),confidence:z.number().min(0).max(100).optional(),payload:z.record(z.unknown()).default({}),citations:z.array(researchCitationSchema).default([])});
export type ResearchRequest=z.infer<typeof researchRequestSchema>;
