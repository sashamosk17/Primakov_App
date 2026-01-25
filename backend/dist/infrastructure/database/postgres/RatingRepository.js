"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.RatingRepository = void 0;
const Result_1 = require("../../../shared/Result");
class RatingRepository {
    async getByTeacher(_teacherId) {
        return Result_1.Result.fail("Not implemented");
    }
    async save(_rating) {
        return Result_1.Result.fail("Not implemented");
    }
    async update(_rating) {
        return Result_1.Result.fail("Not implemented");
    }
}
exports.RatingRepository = RatingRepository;
