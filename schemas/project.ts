import { z } from "zod";

export const projectStatusSchema = z.enum([
  "IDEA","DISCOVERY","EVIDENCE_REVIEW","CONCEPT","MVP",
  "VALIDATION","SPECIFICATION","ENGINEERING","ARCHIVED","REJECTED"
]);

export const projectStageSchema = z.enum([
  "INTAKE","PROBLEM","MARKET","TECHNOLOGY","REGULATION",
  "EVIDENCE","CONCEPT","MVP","VALIDATION","SPECIFICATION"
]);

export const projectSchema = z.object({
  projectCode: z.string().min(1).max(50),
  name: z.string().min(1).max(255),
  slug: z.string().min(1).max(255),
  description: z.string().optional(),
  status: projectStatusSchema.default("IDEA"),
  currentStage: projectStageSchema.default("INTAKE")
});

export type ProjectInput = z.infer<typeof projectSchema>;
