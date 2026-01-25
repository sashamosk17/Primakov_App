"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.LoginUseCase = void 0;
const Result_1 = require("../../shared/Result");
class LoginUseCase {
    constructor(authService) {
        this.authService = authService;
    }
    async execute(email, password) {
        const result = await this.authService.login(email, password);
        if (result.isFailure) {
            return Result_1.Result.fail(result.error);
        }
        return Result_1.Result.ok({ user: result.value.user, token: result.value.token });
    }
}
exports.LoginUseCase = LoginUseCase;
