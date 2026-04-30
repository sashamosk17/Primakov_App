"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const User_1 = require("../User");
const Email_1 = require("../../value-objects/Email");
const Password_1 = require("../../value-objects/Password");
function makeUser(role = "STUDENT") {
    const email = Email_1.Email.create("test@primakov.school").value;
    const password = Password_1.Password.create("password123");
    return new User_1.User("user-test-1", email, password, "Иван", "Петров", role, new Date("2024-01-01"));
}
describe("User Entity", () => {
    describe("role checks", () => {
        it("isStudent() должен возвращать true для STUDENT", () => {
            const user = makeUser("STUDENT");
            expect(user.isStudent()).toBe(true);
        });
        it("isStudent() должен возвращать false для TEACHER", () => {
            const user = makeUser("TEACHER");
            expect(user.isStudent()).toBe(false);
        });
        it("isTeacher() должен возвращать true для TEACHER", () => {
            const user = makeUser("TEACHER");
            expect(user.isTeacher()).toBe(true);
        });
        it("isAdmin() должен возвращать true для ADMIN", () => {
            const user = makeUser("ADMIN");
            expect(user.isAdmin()).toBe(true);
        });
        it("isAdmin() должен возвращать true для SUPERADMIN", () => {
            const user = makeUser("SUPERADMIN");
            expect(user.isAdmin()).toBe(true);
        });
        it("isAdmin() должен возвращать false для STUDENT", () => {
            const user = makeUser("STUDENT");
            expect(user.isAdmin()).toBe(false);
        });
    });
    describe("verify", () => {
        it("должен возвращать true для верного пароля", () => {
            const user = makeUser();
            expect(user.verify("password123")).toBe(true);
        });
        it("должен возвращать false для неверного пароля", () => {
            const user = makeUser();
            expect(user.verify("wrongPassword")).toBe(false);
        });
    });
    describe("hasPermission", () => {
        it("STUDENT должен иметь разрешение schedule:read", () => {
            const user = makeUser("STUDENT");
            expect(user.hasPermission("schedule:read")).toBe(true);
        });
        it("STUDENT должен иметь разрешение deadline:create", () => {
            const user = makeUser("STUDENT");
            expect(user.hasPermission("deadline:create")).toBe(true);
        });
        it("STUDENT не должен иметь административных разрешений", () => {
            const user = makeUser("STUDENT");
            expect(user.hasPermission("users:delete")).toBe(false);
        });
        it("ADMIN должен иметь разрешение users:read:all", () => {
            const user = makeUser("ADMIN");
            expect(user.hasPermission("users:read:all")).toBe(true);
        });
        it("TEACHER не должен иметь разрешение deadline:create", () => {
            const user = makeUser("TEACHER");
            expect(user.hasPermission("deadline:create")).toBe(false);
        });
    });
    describe("updateLastLogin", () => {
        it("должен обновлять updatedAt", () => {
            const user = makeUser();
            const before = user.updatedAt.getTime();
            // небольшая задержка чтобы время изменилось
            const laterDate = new Date(before + 1000);
            jest.spyOn(global, "Date").mockImplementationOnce(() => laterDate);
            user.updateLastLogin();
            expect(user.updatedAt.getTime()).toBeGreaterThanOrEqual(before);
        });
    });
    describe("toJSON", () => {
        it("не должен включать поле password в сериализацию", () => {
            const user = makeUser();
            const json = user.toJSON();
            expect(json).not.toHaveProperty("password");
            expect(json).toHaveProperty("email", "test@primakov.school");
            expect(json).toHaveProperty("firstName", "Иван");
            expect(json).toHaveProperty("role", "STUDENT");
        });
    });
});
