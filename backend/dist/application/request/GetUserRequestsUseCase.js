"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.GetUserRequestsUseCase = void 0;
class GetUserRequestsUseCase {
    constructor(requestRepository) {
        this.requestRepository = requestRepository;
    }
    async execute(userId) {
        return await this.requestRepository.getByCreator(userId);
    }
}
exports.GetUserRequestsUseCase = GetUserRequestsUseCase;
