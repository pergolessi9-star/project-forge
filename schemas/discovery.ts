import { z } from "zod";

export const evidenceStatusSchema=z.enum(["VERIFIED","DERIVED","DECLARED","SCENARIO","PENDING"]);
export const reviewDecisionSchema=z.enum(["ACCEPT","REJECT","REQUEST_CHANGES"]);
export const gateStatusSchema=z.enum(["PENDING","READY","ADVANCE","HOLD","REWORK","REJECT"]);
export const stageSchema=z.enum(["INTAKE","PROBLEM","MARKET","TECHNOLOGY","REGULATION","EVIDENCE","CONCEPT","MVP","VALIDATION","SPECIFICATION"]);

export const problemSchema=z.object({statement:z.string().trim().min(1).max(5000),severity:z.number().int().min(1).max(5).optional(),evidenceStatus:evidenceStatusSchema.default("PENDING")});
export const customerSchema=z.object({name:z.string().trim().min(1).max(255),segment:z.string().max(1000).optional(),need:z.string().max(5000).optional(),evidenceStatus:evidenceStatusSchema.default("PENDING")});
export const marketSchema=z.object({name:z.string().trim().min(1).max(255),geography:z.string().max(255).optional(),tam:z.number().nonnegative().optional(),sam:z.number().nonnegative().optional(),som:z.number().nonnegative().optional(),growthRate:z.number().optional(),evidenceStatus:evidenceStatusSchema.default("PENDING")});
export const competitorSchema=z.object({name:z.string().trim().min(1).max(255),url:z.string().url().optional(),positioning:z.string().max(5000).optional(),strengths:z.string().max(5000).optional(),weaknesses:z.string().max(5000).optional(),evidenceStatus:evidenceStatusSchema.default("PENDING")});
export const technologySchema=z.object({name:z.string().trim().min(1).max(255),maturity:z.string().max(255).optional(),description:z.string().max(5000).optional(),evidenceStatus:evidenceStatusSchema.default("PENDING")});
export const regulationSchema=z.object({name:z.string().trim().min(1).max(255),jurisdiction:z.string().max(255).optional(),applicability:z.string().max(5000).optional(),evidenceStatus:evidenceStatusSchema.default("PENDING")});
export const evidenceSourceSchema=z.object({title:z.string().trim().min(1).max(500),sourceType:z.string().max(100).optional(),sourceUrl:z.string().url().optional(),publisher:z.string().max(255).optional(),metadata:z.record(z.string(),z.unknown()).optional()});
export const evidenceSchema=z.object({sourceId:z.string().uuid().optional(),claim:z.string().trim().min(1).max(10000),status:evidenceStatusSchema.default("PENDING"),confidence:z.number().min(0).max(100).optional(),excerpt:z.string().max(10000).optional(),locator:z.string().max(1000).optional()});
export const humanVerificationSchema=z.object({reviewer:z.string().trim().min(1).max(255),decision:reviewDecisionSchema,rationale:z.string().max(10000).optional()});
export const gateReviewSchema=z.object({reviewer:z.string().trim().min(1).max(255),status:gateStatusSchema,rationale:z.string().max(10000).optional()});

export type ProblemInput=z.infer<typeof problemSchema>;
export type EvidenceInput=z.infer<typeof evidenceSchema>;
