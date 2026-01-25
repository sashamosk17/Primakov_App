"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ScheduleRepository = void 0;
const Result_1 = require("../../../shared/Result");
class ScheduleRepository {
    async getScheduleByGroup(_groupId) {
        return Result_1.Result.fail("Not implemented");
    }
    async getScheduleByDate(_groupId, _date) {
        return Result_1.Result.fail("Not implemented");
    }
    async save(_schedule) {
        return Result_1.Result.fail("Not implemented");
    }
}
exports.ScheduleRepository = ScheduleRepository;
