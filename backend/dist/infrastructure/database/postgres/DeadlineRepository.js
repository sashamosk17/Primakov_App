"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.DeadlineRepository = void 0;
const Result_1 = require("../../../shared/Result");
class DeadlineRepository {
    async getByUser(_userId) {
        return Result_1.Result.fail("Not implemented");
    }
    async save(_deadline) {
        return Result_1.Result.fail("Not implemented");
    }
    async update(_deadline) {
        return Result_1.Result.fail("Not implemented");
    }
}
exports.DeadlineRepository = DeadlineRepository;
