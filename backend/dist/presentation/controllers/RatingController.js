"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.RatingController = void 0;
const crypto_1 = require("crypto");
const Rating_1 = require("../../domain/entities/Rating");
class RatingController {
    constructor(rateTeacherUseCase, getTeacherRatingsUseCase) {
        this.rateTeacherUseCase = rateTeacherUseCase;
        this.getTeacherRatingsUseCase = getTeacherRatingsUseCase;
        this.rateTeacher = async (req, res, next) => {
            try {
                const userId = req.user?.userId || "";
                const { teacherId, value } = req.body;
                const rating = new Rating_1.Rating((0, crypto_1.randomUUID)(), teacherId, userId, value, new Date());
                const result = await this.rateTeacherUseCase.execute(rating);
                if (result.isFailure) {
                    return res.status(400).json({ status: "error", error: { message: result.error } });
                }
                return res.status(201).json({ status: "success" });
            }
            catch (error) {
                return next(error);
            }
        };
        this.getRatings = async (req, res, next) => {
            try {
                const { teacherId } = req.params;
                const result = await this.getTeacherRatingsUseCase.execute(teacherId);
                return res.json({ status: "success", data: result.value });
            }
            catch (error) {
                return next(error);
            }
        };
    }
}
exports.RatingController = RatingController;
