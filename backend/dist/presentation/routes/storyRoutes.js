"use strict";
/*
 * Routes for story management endpoints
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.storyRoutes = void 0;
const express_1 = require("express");
const StoryController_1 = require("../controllers/StoryController");
const GetStoriesUseCase_1 = require("../../application/story/GetStoriesUseCase");
const MarkStoryAsViewedUseCase_1 = require("../../application/story/MarkStoryAsViewedUseCase");
const MockStoryRepository_1 = require("../../infrastructure/database/mock/MockStoryRepository");
const storyRoutes = () => {
    const router = (0, express_1.Router)();
    const storyRepository = new MockStoryRepository_1.MockStoryRepository();
    const getStoriesUseCase = new GetStoriesUseCase_1.GetStoriesUseCase(storyRepository);
    const markStoryAsViewedUseCase = new MarkStoryAsViewedUseCase_1.MarkStoryAsViewedUseCase(storyRepository);
    const controller = new StoryController_1.StoryController(getStoriesUseCase, markStoryAsViewedUseCase);
    router.get("/", controller.getStories);
    router.post("/:storyId/view", controller.markAsViewed);
    return router;
};
exports.storyRoutes = storyRoutes;
