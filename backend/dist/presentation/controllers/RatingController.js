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
                const { teacherId, rate, comment } = req.body;
                if (!teacherId || !rate) {
                    return res.status(400).json({
                        status: "error",
                        error: { message: "teacherId and rate are required" }
                    });
                }
                const rating = new Rating_1.Rating((0, crypto_1.randomUUID)(), teacherId, userId, rate, new Date(), comment || '');
                const result = await this.rateTeacherUseCase.execute(rating);
                if (result.isFailure) {
                    return res.status(400).json({ status: "error", error: { message: result.error } });
                }
                return res.status(201).json({
                    status: "success",
                    data: {
                        id: rating.id,
                        teacherId: rating.teacherId,
                        studentId: rating.userId,
                        rate: rating.value,
                        comment: rating.comment,
                        createdAt: rating.createdAt.toISOString()
                    }
                });
            }
            catch (error) {
                return next(error);
            }
        };
        this.getRatings = async (req, res, next) => {
            try {
                const { teacherId } = req.query;
                if (!teacherId || typeof teacherId !== 'string') {
                    return res.status(400).json({ status: "error", error: { message: "teacherId is required" } });
                }
                const result = await this.getTeacherRatingsUseCase.execute(teacherId);
                if (result.isFailure) {
                    return res.status(400).json({ status: "error", error: { message: result.error } });
                }
                // Проверяем, является ли пользователь админом
                const isAdmin = req.user?.role === "ADMIN" || req.user?.role === "SUPERADMIN";
                // Map to Flutter-compatible format
                const ratings = result.value?.map(r => ({
                    id: r.id,
                    teacherId: r.teacherId,
                    // studentId показываем только админам для модерации
                    ...(isAdmin && { studentId: r.userId }),
                    rate: r.value,
                    comment: r.comment,
                    createdAt: r.createdAt.toISOString(),
                })) || [];
                return res.json({ status: "success", data: ratings });
            }
            catch (error) {
                return next(error);
            }
        };
    }
}
exports.RatingController = RatingController;
