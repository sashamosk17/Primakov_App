import { Router } from "express";
import { AuthController } from "../controllers/AuthController";
import { AuthService } from "../../domain/services/AuthService";
import { LoginUseCase } from "../../application/auth/LoginUseCase";
import { RegisterUseCase } from "../../application/auth/RegisterUseCase";
import type { IUserRepository } from "../../domain/repositories/IUserRepository";

export const authRoutes = (userRepository: IUserRepository) => {
  const router = Router();
  const authService = new AuthService(userRepository);
  const controller = new AuthController(new LoginUseCase(authService), new RegisterUseCase(authService));

  router.post("/login", controller.login);
  router.post("/register", controller.register);

  return router;
};
