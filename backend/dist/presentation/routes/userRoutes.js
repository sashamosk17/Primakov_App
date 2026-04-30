"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.userRoutes = void 0;
const express_1 = require("express");
const UserController_1 = require("../controllers/UserController");
const GetTeachersUseCase_1 = require("../../application/user/GetTeachersUseCase");
const GetCurrentUserUseCase_1 = require("../../application/user/GetCurrentUserUseCase");
const UpdateProfileUseCase_1 = require("../../application/user/UpdateProfileUseCase");
const ChangePasswordUseCase_1 = require("../../application/user/ChangePasswordUseCase");
const authMiddleware_1 = require("../middleware/authMiddleware");
const userRoutes = (repository) => {
    const router = (0, express_1.Router)();
    const controller = new UserController_1.UserController(new GetTeachersUseCase_1.GetTeachersUseCase(repository), new GetCurrentUserUseCase_1.GetCurrentUserUseCase(repository), new UpdateProfileUseCase_1.UpdateProfileUseCase(repository), new ChangePasswordUseCase_1.ChangePasswordUseCase(repository));
    // Публичный — список учителей для рейтингов
    router.get("/teachers", controller.getTeachers);
    // Защищённые — работа с профилем текущего пользователя
    router.get("/me", authMiddleware_1.authMiddleware, controller.getMe);
    router.put("/me", authMiddleware_1.authMiddleware, controller.updateProfile);
    router.put("/me/password", authMiddleware_1.authMiddleware, controller.changePassword);
    return router;
};
exports.userRoutes = userRoutes;
