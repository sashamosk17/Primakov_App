"use strict";
/**
 * In-memory story repository with realistic announcements
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.MockStoryRepository = void 0;
const Result_1 = require("../../../shared/Result");
class MockStoryRepository {
    constructor() {
        this.stories = [];
        this.initializeTestData();
    }
    initializeTestData() {
        const today = new Date();
        this.stories = [
            {
                id: "story-1",
                title: "День открытых дверей",
                description: "Посетите наше школьное мероприятие",
                imageUrl: "https://via.placeholder.com/400x300?text=Open+Day",
                author: "admin",
                createdAt: new Date(today.getTime() - 1 * 24 * 60 * 60 * 1000),
                expiresAt: new Date(today.getTime() + 6 * 24 * 60 * 60 * 1000),
                viewedBy: ["user-1", "user-2"],
            },
            {
                id: "story-2",
                title: "Научная конференция",
                description: "Ученики представляют свои проекты",
                imageUrl: "https://via.placeholder.com/400x300?text=Science+Fair",
                author: "teacher-1",
                createdAt: new Date(today.getTime() - 2 * 24 * 60 * 60 * 1000),
                expiresAt: new Date(today.getTime() + 5 * 24 * 60 * 60 * 1000),
                viewedBy: ["user-1"],
            },
            {
                id: "story-3",
                title: "Спортивный турнир",
                description: "Соревнования по волейболу и баскетболу",
                imageUrl: "https://via.placeholder.com/400x300?text=Sports",
                author: "teacher-2",
                createdAt: today,
                expiresAt: new Date(today.getTime() + 7 * 24 * 60 * 60 * 1000),
                viewedBy: [],
            },
            {
                id: "story-4",
                title: "Концерт музыки",
                description: "Выступление школьного оркестра",
                videoUrl: "https://example.com/video.mp4",
                author: "admin",
                createdAt: new Date(today.getTime() - 3 * 24 * 60 * 60 * 1000),
                expiresAt: new Date(today.getTime() + 4 * 24 * 60 * 60 * 1000),
                viewedBy: ["user-2", "user-3"],
            },
            {
                id: "story-5",
                title: "Благоустройство кампуса",
                description: "Помощь в озеленении школьного двора",
                imageUrl: "https://via.placeholder.com/400x300?text=Cleanup",
                author: "admin",
                createdAt: new Date(today.getTime() - 4 * 24 * 60 * 60 * 1000),
                expiresAt: new Date(today.getTime() + 3 * 24 * 60 * 60 * 1000),
                viewedBy: ["user-1", "user-2", "user-3"],
            },
        ];
    }
    async getAll() {
        const now = new Date();
        const activeStories = this.stories.filter((s) => s.expiresAt > now);
        return Result_1.Result.ok(activeStories);
    }
    async getById(id) {
        const story = this.stories.find((s) => s.id === id);
        return Result_1.Result.ok(story || null);
    }
    async save(story) {
        this.stories.push(story);
        return Result_1.Result.ok();
    }
    async markAsViewed(storyId, userId) {
        const story = this.stories.find((s) => s.id === storyId);
        if (story && !story.viewedBy.includes(userId)) {
            story.viewedBy.push(userId);
        }
        return Result_1.Result.ok();
    }
}
exports.MockStoryRepository = MockStoryRepository;
