"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.MockDeadlineRepository = void 0;
const Result_1 = require("../../../shared/Result");
class MockDeadlineRepository {
    constructor() {
        this.deadlines = [];
    }
    async getByUser(userId) {
        return Result_1.Result.ok(this.deadlines.filter((d) => d.userId === userId));
    }
    async save(deadline) {
        this.deadlines.push(deadline);
        return Result_1.Result.ok();
    }
    async update(deadline) {
        const index = this.deadlines.findIndex((d) => d.id === deadline.id);
        if (index >= 0) {
            this.deadlines[index] = deadline;
        }
        return Result_1.Result.ok();
    }
}
exports.MockDeadlineRepository = MockDeadlineRepository;
