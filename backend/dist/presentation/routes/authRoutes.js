"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.authRoutes = void 0;
const express_1 = require("express");
const AuthController_1 = require("../controllers/AuthController");
const AuthService_1 = require("../../domain/services/AuthService");
const LoginUseCase_1 = require("../../application/auth/LoginUseCase");
const RegisterUseCase_1 = require("../../application/auth/RegisterUseCase");
const MockUserRepository_1 = require("../../infrastructure/database/mock/MockUserRepository");
const authRoutes = () => {
    const router = (0, express_1.Router)();
    const userRepository = new MockUserRepository_1.MockUserRepository();
    const authService = new AuthService_1.AuthService(userRepository);
    const controller = new AuthController_1.AuthController(new LoginUseCase_1.LoginUseCase(authService), new RegisterUseCase_1.RegisterUseCase(authService));
    router.post("/login", controller.login);
    router.post("/register", controller.register);
    return router;
};
exports.authRoutes = authRoutes;
