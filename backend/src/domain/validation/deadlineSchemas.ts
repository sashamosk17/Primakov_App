import { z } from 'zod';

export const createDeadlineSchema = z.object({
  title: z.string().min(1, 'Title is required').max(200, 'Title too long'),
  description: z.string().max(1000, 'Description too long').optional(),
  dueDate: z.string().datetime('Invalid date format'),
  subject: z.string().min(1, 'Subject is required').max(100, 'Subject too long'),
});

export type CreateDeadlineInput = z.infer<typeof createDeadlineSchema>;
