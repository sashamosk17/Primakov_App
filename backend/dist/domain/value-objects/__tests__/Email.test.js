"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const Email_1 = require("../Email");
describe("Email Value Object", () => {
    describe("create", () => {
        it("должен создавать валидный email", () => {
            const result = Email_1.Email.create("test@example.com");
            expect(result.isSuccess).toBe(true);
            expect(result.value.value).toBe("test@example.com");
        });
        it("должен приводить email к нижнему регистру", () => {
            const result = Email_1.Email.create("Test@Example.COM");
            expect(result.isSuccess).toBe(true);
            expect(result.value.value).toBe("test@example.com");
        });
        it("должен обрезать пробелы", () => {
            const result = Email_1.Email.create("  user@school.ru  ");
            expect(result.isSuccess).toBe(true);
            expect(result.value.value).toBe("user@school.ru");
        });
        it("должен принимать школьный email", () => {
            const result = Email_1.Email.create("ivan.petrov@primakov.school");
            expect(result.isSuccess).toBe(true);
            expect(result.value.value).toBe("ivan.petrov@primakov.school");
        });
        it("должен отклонять строку без символа @", () => {
            const result = Email_1.Email.create("invalid-email");
            expect(result.isFailure).toBe(true);
            expect(result.error).toBeDefined();
        });
        it("должен отклонять строку без домена", () => {
            const result = Email_1.Email.create("user@");
            expect(result.isFailure).toBe(true);
        });
        it("должен отклонять пустую строку", () => {
            const result = Email_1.Email.create("");
            expect(result.isFailure).toBe(true);
        });
        it("должен отклонять строку без точки в домене", () => {
            const result = Email_1.Email.create("user@domain");
            expect(result.isFailure).toBe(true);
        });
    });
    describe("domain", () => {
        it("должен возвращать доменную часть email", () => {
            const email = Email_1.Email.create("student@primakov.school").value;
            expect(email.domain).toBe("primakov.school");
        });
    });
    describe("equals", () => {
        it("должен возвращать true для одинаковых email", () => {
            const email1 = Email_1.Email.create("user@test.com").value;
            const email2 = Email_1.Email.create("user@test.com").value;
            expect(email1.equals(email2)).toBe(true);
        });
        it("должен возвращать false для разных email", () => {
            const email1 = Email_1.Email.create("user1@test.com").value;
            const email2 = Email_1.Email.create("user2@test.com").value;
            expect(email1.equals(email2)).toBe(false);
        });
        it("должен возвращать true для email в разном регистре", () => {
            const email1 = Email_1.Email.create("USER@TEST.COM").value;
            const email2 = Email_1.Email.create("user@test.com").value;
            expect(email1.equals(email2)).toBe(true);
        });
    });
});
