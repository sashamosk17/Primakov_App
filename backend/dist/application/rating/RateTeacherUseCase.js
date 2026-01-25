"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.RateTeacherUseCase = void 0;
class RateTeacherUseCase {
    constructor(ratingService) {
        this.ratingService = ratingService;
    }
    async execute(rating) {
        return this.ratingService.rate(rating);
    }
}
exports.RateTeacherUseCase = RateTeacherUseCase;
