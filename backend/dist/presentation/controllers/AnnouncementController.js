"use strict";
/*
 * Handles HTTP requests for announcement management
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.AnnouncementController = void 0;
class AnnouncementController {
    constructor(getAnnouncementsUseCase, getAnnouncementByCategoryUseCase) {
        this.getAnnouncementsUseCase = getAnnouncementsUseCase;
        this.getAnnouncementByCategoryUseCase = getAnnouncementByCategoryUseCase;
        this.getAnnouncements = async (req, res, next) => {
            try {
                const result = await this.getAnnouncementsUseCase.execute();
                if (result.isFailure) {
                    return res.status(400).json({ status: "error", error: { message: result.error } });
                }
                return res.json({ status: "success", data: result.value });
            }
            catch (error) {
                return next(error);
            }
        };
        this.getByCategory = async (req, res, next) => {
            try {
                const { category } = req.query;
                if (!category || typeof category !== "string") {
                    return res.status(400).json({
                        status: "error",
                        error: { message: "Category query parameter is required" },
                    });
                }
                const result = await this.getAnnouncementByCategoryUseCase.execute(category);
                if (result.isFailure) {
                    return res.status(400).json({ status: "error", error: { message: result.error } });
                }
                return res.json({ status: "success", data: result.value });
            }
            catch (error) {
                return next(error);
            }
        };
    }
}
exports.AnnouncementController = AnnouncementController;
