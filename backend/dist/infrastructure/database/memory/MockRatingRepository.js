"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.MockRatingRepository = void 0;
const Result_1 = require("../../../shared/Result");
class MockRatingRepository {
    constructor() {
        this.ratings = [];
    }
    async getByTeacher(teacherId) {
        return Result_1.Result.ok(this.ratings.filter((r) => r.teacherId === teacherId));
    }
    async save(rating) {
        this.ratings.push(rating);
        return Result_1.Result.ok();
    }
    async update(rating) {
        const index = this.ratings.findIndex((r) => r.id === rating.id);
        if (index >= 0) {
            this.ratings[index] = rating;
        }
        return Result_1.Result.ok();
    }
}
exports.MockRatingRepository = MockRatingRepository;
