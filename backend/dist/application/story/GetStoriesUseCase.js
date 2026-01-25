"use strict";
/*
 * Use case for retrieving all active stories
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.GetStoriesUseCase = void 0;
class GetStoriesUseCase {
    constructor(storyRepository) {
        this.storyRepository = storyRepository;
    }
    async execute() {
        const result = await this.storyRepository.getAll();
        return result;
    }
}
exports.GetStoriesUseCase = GetStoriesUseCase;
