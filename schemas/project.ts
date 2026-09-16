import { z } from "zod";
export const projectStatusSchema=z.enum(["IDEA","DISCOVERY","EVIDENCE_REVIEW","CONCEPT","MVP","VALIDATION","SPECIFICATION","ENGINEERING","ARCHIVED","REJECTED"]);
export const projectStageSchema=z.enum(["INTAKE","PROBLEM","MARKET","TECHNOLOGY","REGULATION","EVIDENCE","CONCEPT","MVP","VALIDATION","SPECIFICATION"]);
export const projectCreateSchema=z.object({code:z.string().trim().min(1).max(50),name:z.string().trim().min(1).max(255),description:z.string().optional(),status:projectStatusSchema.default("IDEA"),currentStage:projectStageSchema.default("INTAKE"),owner:z.string().max(255).optional(),confidence:z.number().min(0).max(100).optional()});
export const projectUpdateSchema=projectCreateSchema.partial();
export type ProjectCreateInput=z.infer<typeof projectCreateSchema>;
