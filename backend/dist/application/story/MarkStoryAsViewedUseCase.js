"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.MarkStoryAsViewedUseCase = void 0;
const Result_1 = require("../../shared/Result");
class MarkStoryAsViewedUseCase {
    constructor(storyRepository) {
        this.storyRepository = storyRepository;
    }
    async execute(storyId, userId) {
        const storyResult = await this.storyRepository.getById(storyId);
        if (!storyResult.isSuccess || !storyResult.value) {
            return Result_1.Result.fail("Story not found");
        }
        return this.storyRepository.markAsViewed(storyId, userId);
    }
}
exports.MarkStoryAsViewedUseCase = MarkStoryAsViewedUseCase;
