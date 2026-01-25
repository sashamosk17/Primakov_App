"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.RegisterUseCase = void 0;
const Result_1 = require("../../shared/Result");
class RegisterUseCase {
    constructor(authService) {
        this.authService = authService;
    }
    async execute(email, password) {
        const result = await this.authService.register(email, password);
        if (result.isFailure) {
            return Result_1.Result.fail(result.error);
        }
        return Result_1.Result.ok({ token: result.value.token });
    }
}
exports.RegisterUseCase = RegisterUseCase;
