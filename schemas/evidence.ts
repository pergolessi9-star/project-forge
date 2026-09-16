import { z } from "zod";

export const evidenceTypeSchema = z.enum([
  "VERIFIED","DERIVED","DECLARED","SCENARIO","PENDING"
]);

export const evidenceStatusSchema = z.enum([
  "PENDING","UNDER_REVIEW","VERIFIED","REJECTED"
]);

export const evidenceSchema = z.object({
  projectId: z.string().uuid(),
  evidenceCode: z.string().min(1).max(50),
  claim: z.string().min(1),
  evidenceType: evidenceTypeSchema,
  confidence: z.string().optional(),
  status: evidenceStatusSchema.default("PENDING"),
  sourceId: z.string().uuid().optional(),
  extractedText: z.string().optional(),
  structuredData: z.record(z.unknown()).optional()
});

export type EvidenceInput = z.infer<typeof evidenceSchema>;
