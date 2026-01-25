"use strict";
/*
 * In-memory rating repository with teacher ratings
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.MockRatingRepository = void 0;
const Rating_1 = require("../../../domain/entities/Rating");
const Result_1 = require("../../../shared/Result");
class MockRatingRepository {
    constructor() {
        this.ratings = [];
        this.initializeTestData();
    }
    initializeTestData() {
        const teacher1Ratings = [
            { userId: "user-1", value: 5 },
            { userId: "user-2", value: 4 },
            { userId: "user-3", value: 5 },
            { userId: "user-1", value: 4 },
        ];
        teacher1Ratings.forEach((rating, index) => {
            this.ratings.push(new Rating_1.Rating(`rating-teacher1-${index + 1}`, "teacher-1", rating.userId, rating.value, new Date(Date.now() - (10 - index) * 24 * 60 * 60 * 1000), undefined, 0));
        });
        const teacher2Ratings = [
            { userId: "user-1", value: 3 },
            { userId: "user-2", value: 4 },
            { userId: "user-3", value: 4 },
            { userId: "user-2", value: 5 },
        ];
        teacher2Ratings.forEach((rating, index) => {
            this.ratings.push(new Rating_1.Rating(`rating-teacher2-${index + 1}`, "teacher-2", rating.userId, rating.value, new Date(Date.now() - (12 - index) * 24 * 60 * 60 * 1000), undefined, 0));
        });
    }
    async getByTeacher(teacherId) {
        const teacherRatings = this.ratings.filter((r) => r.teacherId === teacherId);
        return Result_1.Result.ok(teacherRatings);
    }
    async save(rating) {
        this.ratings.push(rating);
        return Result_1.Result.ok();
    }
    async update(rating) {
        const existingIndex = this.ratings.findIndex((r) => r.id === rating.id);
        if (existingIndex >= 0) {
            this.ratings[existingIndex] = rating;
        }
        return Result_1.Result.ok();
    }
}
exports.MockRatingRepository = MockRatingRepository;
