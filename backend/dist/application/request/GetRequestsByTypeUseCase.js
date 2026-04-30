"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.GetRequestsByTypeUseCase = void 0;
class GetRequestsByTypeUseCase {
    constructor(requestRepository) {
        this.requestRepository = requestRepository;
    }
    async execute(type) {
        return await this.requestRepository.getByType(type);
    }
}
exports.GetRequestsByTypeUseCase = GetRequestsByTypeUseCase;
