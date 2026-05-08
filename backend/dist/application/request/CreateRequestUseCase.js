"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.CreateRequestUseCase = void 0;
class CreateRequestUseCase {
    constructor(requestRepository) {
        this.requestRepository = requestRepository;
    }
    async execute(request) {
        return await this.requestRepository.save(request);
    }
}
exports.CreateRequestUseCase = CreateRequestUseCase;
