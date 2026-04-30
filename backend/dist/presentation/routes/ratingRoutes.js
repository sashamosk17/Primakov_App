"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ratingRoutes = void 0;
const express_1 = require("express");
const RatingController_1 = require("../controllers/RatingController");
const RateTeacherUseCase_1 = require("../../application/rating/RateTeacherUseCase");
const GetTeacherRatingsUseCase_1 = require("../../application/rating/GetTeacherRatingsUseCase");
const RatingService_1 = require("../../domain/services/RatingService");
const MockRatingRepository_1 = require("../../infrastructure/database/memory/MockRatingRepository");
const authMiddleware_1 = require("../middleware/authMiddleware");
const ratingRoutes = (repository) => {
    const router = (0, express_1.Router)();
    const service = new RatingService_1.RatingService(repository || new MockRatingRepository_1.MockRatingRepository());
    const controller = new RatingController_1.RatingController(new RateTeacherUseCase_1.RateTeacherUseCase(service), new GetTeacherRatingsUseCase_1.GetTeacherRatingsUseCase(service));
    router.get("/", authMiddleware_1.authMiddleware, controller.getRatings);
    router.post("/", authMiddleware_1.authMiddleware, controller.rateTeacher);
    return router;
};
exports.ratingRoutes = ratingRoutes;
