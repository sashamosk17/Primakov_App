"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.AuthController = void 0;
class AuthController {
    constructor(loginUseCase, registerUseCase) {
        this.loginUseCase = loginUseCase;
        this.registerUseCase = registerUseCase;
        this.login = async (req, res, next) => {
            try {
                const { email, password } = req.body;
                console.log("Login attempt:", { email, password });
                const result = await this.loginUseCase.execute(email, password);
                console.log("Login result:", { isFailure: result.isFailure, error: result.error });
                if (result.isFailure) {
                    return res.status(401).json({ status: "error", error: { message: result.error } });
                }
                return res.json({ status: "success", data: result.value });
            }
            catch (error) {
                return next(error);
            }
        };
        this.register = async (req, res, next) => {
            try {
                const { email, password } = req.body;
                const result = await this.registerUseCase.execute(email, password);
                if (result.isFailure) {
                    return res.status(400).json({ status: "error", error: { message: result.error } });
                }
                return res.status(201).json({ status: "success", data: result.value });
            }
            catch (error) {
                return next(error);
            }
        };
    }
}
exports.AuthController = AuthController;
