import { z } from "zod";

export const validationExperimentSchema = z.object({
  projectId: z.string().uuid(),
  name: z.string().min(1),
  hypothesis: z.string().min(1),
  method: z.string().optional(),
  targetUsers: z.string().optional(),
  metrics: z.record(z.unknown()).optional(),
  successCriteria: z.record(z.unknown()).optional()
});
