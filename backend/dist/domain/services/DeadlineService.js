"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.DeadlineService = void 0;
class DeadlineService {
    constructor(deadlineRepository) {
        this.deadlineRepository = deadlineRepository;
    }
    async getUserDeadlines(userId) {
        return this.deadlineRepository.getByUser(userId);
    }
    async create(deadline) {
        return this.deadlineRepository.save(deadline);
    }
    async complete(deadline) {
        return this.deadlineRepository.update(deadline);
    }
}
exports.DeadlineService = DeadlineService;
