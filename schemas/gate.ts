import { z } from "zod";
export const gateStatusSchema = z.enum(["PENDING","READY","ADVANCE","HOLD","REWORK","REJECT"]);
export const gateReviewSchema = z.object({ gateId: z.string().uuid(), decision: gateStatusSchema, rationale: z.string().optional(), evidenceIds: z.array(z.string().uuid()).default([]) });
