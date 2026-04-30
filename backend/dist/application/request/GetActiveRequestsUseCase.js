"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.GetActiveRequestsUseCase = void 0;
class GetActiveRequestsUseCase {
    constructor(requestRepository) {
        this.requestRepository = requestRepository;
    }
    async execute() {
        return await this.requestRepository.getActive();
    }
}
exports.GetActiveRequestsUseCase = GetActiveRequestsUseCase;
