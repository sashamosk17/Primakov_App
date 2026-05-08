"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const Password_1 = require("../Password");
describe("Password Value Object", () => {
    describe("create", () => {
        it("должен создавать хэш пароля из открытого текста", () => {
            const password = Password_1.Password.create("password123");
            expect(password).toBeInstanceOf(Password_1.Password);
            expect(password.hash).toBeDefined();
            expect(password.hash).not.toBe("password123");
        });
        it("хэш должен начинаться с префикса bcrypt", () => {
            const password = Password_1.Password.create("mySecret");
            // bcrypt хэши начинаются с $2b$ или $2a$
            expect(password.hash).toMatch(/^\$2[ab]\$/);
        });
        it("два пароля с одинаковым текстом должны иметь разные хэши (соль)", () => {
            const password1 = Password_1.Password.create("samePassword");
            const password2 = Password_1.Password.create("samePassword");
            // bcrypt использует соль, поэтому хэши разные
            expect(password1.hash).not.toBe(password2.hash);
        });
    });
    describe("fromHash", () => {
        it("должен создавать Password из уже готового хэша", () => {
            const original = Password_1.Password.create("testPass");
            const restored = Password_1.Password.fromHash(original.hash);
            expect(restored.hash).toBe(original.hash);
        });
    });
    describe("compare", () => {
        it("должен возвращать true для верного пароля", () => {
            const password = Password_1.Password.create("correctPassword");
            expect(password.compare("correctPassword")).toBe(true);
        });
        it("должен возвращать false для неверного пароля", () => {
            const password = Password_1.Password.create("correctPassword");
            expect(password.compare("wrongPassword")).toBe(false);
        });
        it("должен возвращать false для пустой строки", () => {
            const password = Password_1.Password.create("somePassword");
            expect(password.compare("")).toBe(false);
        });
        it("должен быть чувствителен к регистру", () => {
            const password = Password_1.Password.create("CaseSensitive");
            expect(password.compare("casesensitive")).toBe(false);
            expect(password.compare("CaseSensitive")).toBe(true);
        });
    });
});
