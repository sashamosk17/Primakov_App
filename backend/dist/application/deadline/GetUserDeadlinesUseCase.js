"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.GetUserDeadlinesUseCase = void 0;
class GetUserDeadlinesUseCase {
    constructor(deadlineService) {
        this.deadlineService = deadlineService;
    }
    async execute(userId) {
        return this.deadlineService.getUserDeadlines(userId);
    }
}
exports.GetUserDeadlinesUseCase = GetUserDeadlinesUseCase;
