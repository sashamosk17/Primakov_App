"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.GetTeacherRatingsUseCase = void 0;
class GetTeacherRatingsUseCase {
    constructor(ratingService) {
        this.ratingService = ratingService;
    }
    async execute(teacherId) {
        return this.ratingService.getTeacherRatings(teacherId);
    }
}
exports.GetTeacherRatingsUseCase = GetTeacherRatingsUseCase;
