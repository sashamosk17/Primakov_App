"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.GetCurrentUserUseCase = void 0;
const Result_1 = require("../../shared/Result");
class GetCurrentUserUseCase {
    constructor(userRepository) {
        this.userRepository = userRepository;
    }
    async execute(userId) {
        const result = await this.userRepository.findById(userId);
        if (result.isFailure) {
            return Result_1.Result.fail(result.error);
        }
        if (!result.value) {
            return Result_1.Result.fail("User not found");
        }
        return Result_1.Result.ok(result.value);
    }
}
exports.GetCurrentUserUseCase = GetCurrentUserUseCase;
