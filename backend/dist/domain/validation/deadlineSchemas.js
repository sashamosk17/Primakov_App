"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createDeadlineSchema = void 0;
const zod_1 = require("zod");
exports.createDeadlineSchema = zod_1.z.object({
    title: zod_1.z.string().min(1, 'Title is required').max(200, 'Title too long'),
    description: zod_1.z.string().max(1000, 'Description too long').optional(),
    dueDate: zod_1.z.string().datetime('Invalid date format'),
    subject: zod_1.z.string().min(1, 'Subject is required').max(100, 'Subject too long'),
});
