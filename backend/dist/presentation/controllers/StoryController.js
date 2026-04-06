"use strict";
/**
 * StoryController
 * Handles HTTP requests for story management
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.StoryController = void 0;
class StoryController {
    constructor(getStoriesUseCase, markStoryAsViewedUseCase) {
        this.getStoriesUseCase = getStoriesUseCase;
        this.markStoryAsViewedUseCase = markStoryAsViewedUseCase;
        this.getStories = async (req, res, next) => {
            try {
                const result = await this.getStoriesUseCase.execute();
                if (result.isFailure) {
                    return res.status(400).json({ status: "error", error: { message: result.error } });
                }
                return res.json({ status: "success", data: result.value });
            }
            catch (error) {
                return next(error);
            }
        };
        this.markAsViewed = async (req, res, next) => {
            try {
                const { storyId } = req.params;
                const userId = req.userId; // From auth middleware
                const result = await this.markStoryAsViewedUseCase.execute(storyId, userId);
                if (result.isFailure) {
                    return res.status(400).json({ status: "error", error: { message: result.error } });
                }
                return res.json({ status: "success", data: {} });
            }
            catch (error) {
                return next(error);
            }
        };
    }
}
exports.StoryController = StoryController;
