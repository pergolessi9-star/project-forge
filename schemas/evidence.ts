import { z } from "zod";
export const evidenceStatusSchema=z.enum(["VERIFIED","DERIVED","DECLARED","SCENARIO","PENDING"]);
export const evidenceSchema=z.object({projectId:z.string().uuid(),sourceId:z.string().uuid().optional(),claim:z.string().trim().min(1),status:evidenceStatusSchema.default("PENDING"),confidence:z.number().min(0).max(100).optional(),excerpt:z.string().optional(),locator:z.string().optional()});
export type EvidenceInput=z.infer<typeof evidenceSchema>;
