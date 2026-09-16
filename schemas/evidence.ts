import { z } from "zod";
export const evidenceTypeSchema = z.enum(["VERIFIED","DERIVED","DECLARED","SCENARIO","PENDING"]);
export const evidenceStatusSchema = z.enum(["PENDING","VERIFIED","REJECTED"]);
export const evidenceSchema = z.object({
  projectId: z.string().uuid(),
  claim: z.string().min(1),
  status: evidenceTypeSchema,
  confidence: z.number().min(0).max(1).optional(),
  sourceId: z.string().uuid().optional(),
  excerpt: z.string().optional(),
  locator: z.string().optional()
});
export type EvidenceInput = z.infer<typeof evidenceSchema>;
