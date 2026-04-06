"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.User = void 0;
const constants_1 = require("../../shared/constants");
class User {
    constructor(id, email, password, firstName, lastName, role, createdAt, updatedAt, isActive = true, vkId) {
        this.id = id;
        this.email = email;
        this.password = password;
        this.firstName = firstName;
        this.lastName = lastName;
        this.role = role;
        this.createdAt = createdAt;
        this.isActive = isActive;
        this.vkId = vkId;
        this.updatedAt = updatedAt ?? createdAt;
    }
    isStudent() {
        return this.role === "STUDENT";
    }
    isTeacher() {
        return this.role === "TEACHER";
    }
    isAdmin() {
        return this.role === "ADMIN" || this.role === "SUPERADMIN";
    }
    hasPermission(permission) {
        return constants_1.ROLE_PERMISSIONS[this.role].includes(permission);
    }
    verify(password) {
        return this.password.compare(password);
    }
    updateLastLogin() {
        this.updatedAt = new Date();
    }
    toJSON() {
        return {
            id: this.id,
            email: this.email.value,
            firstName: this.firstName,
            lastName: this.lastName,
            role: this.role,
            createdAt: this.createdAt.toISOString(),
            updatedAt: this.updatedAt.toISOString(),
            isActive: this.isActive,
            vkId: this.vkId,
        };
    }
}
exports.User = User;
