"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.MockScheduleRepository = void 0;
const Result_1 = require("../../../shared/Result");
class MockScheduleRepository {
    constructor() {
        this.schedules = [];
    }
    async getScheduleByGroup(groupId) {
        const schedule = this.schedules.find((s) => s.groupId === groupId) || null;
        return Result_1.Result.ok(schedule);
    }
    async getScheduleByDate(groupId, date) {
        const schedule = this.schedules.find((s) => s.groupId === groupId && s.date.toDateString() === date.toDateString()) ||
            null;
        return Result_1.Result.ok(schedule);
    }
    async save(schedule) {
        this.schedules.push(schedule);
        return Result_1.Result.ok();
    }
}
exports.MockScheduleRepository = MockScheduleRepository;
