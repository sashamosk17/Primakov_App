"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.RatingService = void 0;
class RatingService {
    constructor(ratingRepository) {
        this.ratingRepository = ratingRepository;
    }
    async rate(rating) {
        return this.ratingRepository.save(rating);
    }
    async getTeacherRatings(teacherId) {
        return this.ratingRepository.getByTeacher(teacherId);
    }
}
exports.RatingService = RatingService;
