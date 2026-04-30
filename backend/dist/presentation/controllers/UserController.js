"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.UserController = void 0;
class UserController {
    constructor(getTeachersUseCase, getCurrentUserUseCase, updateProfileUseCase, changePasswordUseCase) {
        this.getTeachersUseCase = getTeachersUseCase;
        this.getCurrentUserUseCase = getCurrentUserUseCase;
        this.updateProfileUseCase = updateProfileUseCase;
        this.changePasswordUseCase = changePasswordUseCase;
        this.getTeachers = async (req, res, next) => {
            try {
                const result = await this.getTeachersUseCase.execute();
                if (result.isFailure) {
                    return res.status(400).json({ status: "error", error: { message: result.error } });
                }
                const teachers = result.value?.map(teacher => ({
                    id: teacher.id,
                    firstName: teacher.firstName,
                    lastName: teacher.lastName,
                    fullName: `${teacher.lastName} ${teacher.firstName}`,
                })) || [];
                return res.json({ status: "success", data: teachers });
            }
            catch (error) {
                return next(error);
            }
        };
        // --- НОВЫЙ: GET /api/users/me ---
        this.getMe = async (req, res, next) => {
            try {
                const userId = req.user.userId;
                const result = await this.getCurrentUserUseCase.execute(userId);
                if (result.isFailure) {
                    return res.status(404).json({
                        status: "error",
                        error: { message: result.error }
                    });
                }
                return res.json({
                    status: "success",
                    data: result.value.toJSON()
                });
            }
            catch (error) {
                return next(error);
            }
        };
        // --- НОВЫЙ: PUT /api/users/me ---
        this.updateProfile = async (req, res, next) => {
            try {
                const userId = req.user.userId;
                const { firstName, lastName } = req.body;
                const result = await this.updateProfileUseCase.execute({
                    userId,
                    firstName,
                    lastName,
                });
                if (result.isFailure) {
                    return res.status(400).json({
                        status: "error",
                        error: { message: result.error }
                    });
                }
                return res.json({
                    status: "success",
                    data: result.value.toJSON()
                });
            }
            catch (error) {
                return next(error);
            }
        };
        // --- НОВЫЙ: PUT /api/users/me/password ---
        this.changePassword = async (req, res, next) => {
            try {
                const userId = req.user.userId;
                const { currentPassword, newPassword } = req.body;
                // Быстрая проверка обязательных полей до вызова use case
                if (!currentPassword || !newPassword) {
                    return res.status(400).json({
                        status: "error",
                        error: { message: "currentPassword and newPassword are required" }
                    });
                }
                const result = await this.changePasswordUseCase.execute({
                    userId,
                    currentPassword,
                    newPassword,
                });
                if (result.isFailure) {
                    return res.status(400).json({
                        status: "error",
                        error: { message: result.error }
                    });
                }
                return res.json({
                    status: "success",
                    data: { message: "Password changed successfully" }
                });
            }
            catch (error) {
                return next(error);
            }
        };
    }
}
exports.UserController = UserController;
