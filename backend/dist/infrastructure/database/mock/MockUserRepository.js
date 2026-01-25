"use strict";
/*
 * In-memory user repository with realistic test data
 * Used for development and testing before database integration
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.MockUserRepository = void 0;
const User_1 = require("../../../domain/entities/User");
const Result_1 = require("../../../shared/Result");
const Email_1 = require("../../../domain/value-objects/Email");
const Password_1 = require("../../../domain/value-objects/Password");
class MockUserRepository {
    constructor() {
        this.users = [];
        this.initializeTestData();
    }
    initializeTestData() {
        // Test students
        const student1Email = Email_1.Email.create("ivan.petrov@primakov.school").value;
        const student1Pass = Password_1.Password.create("password123");
        this.users.push(new User_1.User("user-1", student1Email, student1Pass, "Иван", "Петров", "STUDENT", new Date("2024-01-01"), undefined, true, undefined));
        const student2Email = Email_1.Email.create("maria.sokolova@primakov.school").value;
        const student2Pass = Password_1.Password.create("password123");
        this.users.push(new User_1.User("user-2", student2Email, student2Pass, "Мария", "Соколова", "STUDENT", new Date("2024-01-01"), undefined, true, undefined));
        const student3Email = Email_1.Email.create("aleksei.smirnov@primakov.school").value;
        const student3Pass = Password_1.Password.create("password123");
        this.users.push(new User_1.User("user-3", student3Email, student3Pass, "Алексей", "Смирнов", "STUDENT", new Date("2024-01-01"), undefined, true, undefined));
        // Test teachers
        const teacher1Email = Email_1.Email.create("teacher.ivanov@primakov.school").value;
        const teacher1Pass = Password_1.Password.create("password123");
        this.users.push(new User_1.User("teacher-1", teacher1Email, teacher1Pass, "Иван", "Иванов", "TEACHER", new Date("2024-01-01"), undefined, true, undefined));
        const teacher2Email = Email_1.Email.create("teacher.sidorov@primakov.school").value;
        const teacher2Pass = Password_1.Password.create("password123");
        this.users.push(new User_1.User("teacher-2", teacher2Email, teacher2Pass, "Виктор", "Сидоров", "TEACHER", new Date("2024-01-01"), undefined, true, undefined));
        // Admin
        const adminEmail = Email_1.Email.create("admin@primakov.school").value;
        const adminPass = Password_1.Password.create("password123");
        this.users.push(new User_1.User("admin-1", adminEmail, adminPass, "Администратор", "Примаков", "ADMIN", new Date("2024-01-01"), undefined, true, undefined));
    }
    async findById(id) {
        const user = this.users.find((u) => u.id === id);
        return Result_1.Result.ok(user || null);
    }
    async findByEmail(email) {
        const user = this.users.find((u) => u.email.value === email.toLowerCase());
        return Result_1.Result.ok(user || null);
    }
    async save(user) {
        const existingIndex = this.users.findIndex((u) => u.id === user.id);
        if (existingIndex >= 0) {
            this.users[existingIndex] = user;
        }
        else {
            this.users.push(user);
        }
        return Result_1.Result.ok();
    }
}
exports.MockUserRepository = MockUserRepository;
