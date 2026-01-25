"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ROLE_PERMISSIONS = void 0;
exports.ROLE_PERMISSIONS = {
    STUDENT: [
        "schedule:read",
        "deadline:create",
        "deadline:read",
        "deadline:update:own",
        "rating:create",
        "rating:update:own",
        "review:read"
    ],
    TEACHER: ["schedule:read", "review:read:own", "rating:read:own"],
    ADMIN: [
        "schedule:read",
        "users:create",
        "users:read:all",
        "users:update",
        "users:delete",
        "analytics:read"
    ],
    SUPERADMIN: [
        "schedule:read",
        "users:create",
        "users:read:all",
        "users:update",
        "users:delete",
        "analytics:read"
    ]
};
