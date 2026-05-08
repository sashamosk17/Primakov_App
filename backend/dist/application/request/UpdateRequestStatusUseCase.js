"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.UpdateRequestStatusUseCase = void 0;
class UpdateRequestStatusUseCase {
    constructor(requestRepository) {
        this.requestRepository = requestRepository;
    }
    async execute(request) {
        return await this.requestRepository.update(request);
    }
}
exports.UpdateRequestStatusUseCase = UpdateRequestStatusUseCase;
