"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.MockUserRepository = void 0;
const Result_1 = require("../../../shared/Result");
class MockUserRepository {
    constructor() {
        this.users = [];
    }
    async findById(id) {
        const user = this.users.find((u) => u.id === id) || null;
        return Result_1.Result.ok(user);
    }
    async findByEmail(email) {
        const user = this.users.find((u) => u.email.value === email) || null;
        return Result_1.Result.ok(user);
    }
    async save(user) {
        this.users.push(user);
        return Result_1.Result.ok();
    }
}
exports.MockUserRepository = MockUserRepository;
