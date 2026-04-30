"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.registerSchema = exports.loginSchema = void 0;
const zod_1 = require("zod");
exports.loginSchema = zod_1.z.object({
    email: zod_1.z.string().email('Invalid email format').min(1, 'Email is required'),
    password: zod_1.z.string().min(6, 'Password must be at least 6 characters'),
});
exports.registerSchema = zod_1.z.object({
    email: zod_1.z.string().email('Invalid email format').min(1, 'Email is required'),
    password: zod_1.z.string()
        .min(8, 'Password must be at least 8 characters')
        .regex(/[A-Z]/, 'Password must contain at least one uppercase letter')
        .regex(/[a-z]/, 'Password must contain at least one lowercase letter')
        .regex(/[0-9]/, 'Password must contain at least one number'),
    name: zod_1.z.string().min(1, 'Name is required').max(100, 'Name too long'),
    group: zod_1.z.string().min(1, 'Group is required').max(50, 'Group too long'),
    role: zod_1.z.enum(['student', 'teacher', 'admin']).optional(),
});
