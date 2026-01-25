"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.CompleteDeadlineUseCase = void 0;
class CompleteDeadlineUseCase {
    constructor(deadlineService) {
        this.deadlineService = deadlineService;
    }
    async execute(deadline) {
        return this.deadlineService.complete(deadline);
    }
}
exports.CompleteDeadlineUseCase = CompleteDeadlineUseCase;
