import { Router } from "express";
import { UserController } from "../controllers/UserController";
import { GetTeachersUseCase } from "../../application/user/GetTeachersUseCase";
import { GetCurrentUserUseCase } from "../../application/user/GetCurrentUserUseCase";
import { UpdateProfileUseCase } from "../../application/user/UpdateProfileUseCase";
import { ChangePasswordUseCase } from "../../application/user/ChangePasswordUseCase";
import { authMiddleware } from "../middleware/authMiddleware";
import type { IUserRepository } from "../../domain/repositories/IUserRepository";

export const userRoutes = (repository: IUserRepository) => {
  const router = Router();

  const controller = new UserController(
    new GetTeachersUseCase(repository),
    new GetCurrentUserUseCase(repository),
    new UpdateProfileUseCase(repository),
    new ChangePasswordUseCase(repository),
  );

  // Публичный — список учителей для рейтингов
  router.get("/teachers", controller.getTeachers);

  // Защищённые — работа с профилем текущего пользователя
  router.get("/me",          authMiddleware, controller.getMe);
  router.put("/me",          authMiddleware, controller.updateProfile);
  router.put("/me/password", authMiddleware, controller.changePassword);

  return router;
};
