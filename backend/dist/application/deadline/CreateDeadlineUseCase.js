"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.CreateDeadlineUseCase = void 0;
class CreateDeadlineUseCase {
    constructor(deadlineService) {
        this.deadlineService = deadlineService;
    }
    async execute(deadline) {
        return this.deadlineService.create(deadline);
    }
}
exports.CreateDeadlineUseCase = CreateDeadlineUseCase;
