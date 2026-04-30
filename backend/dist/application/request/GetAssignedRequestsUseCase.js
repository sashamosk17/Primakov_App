"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.GetAssignedRequestsUseCase = void 0;
class GetAssignedRequestsUseCase {
    constructor(requestRepository) {
        this.requestRepository = requestRepository;
    }
    async execute(assigneeId) {
        return await this.requestRepository.getByAssignee(assigneeId);
    }
}
exports.GetAssignedRequestsUseCase = GetAssignedRequestsUseCase;
