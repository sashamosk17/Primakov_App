import { Router } from "express";
import { DeadlineController } from "../controllers/DeadlineController";
import { CreateDeadlineUseCase } from "../../application/deadline/CreateDeadlineUseCase";
import { GetUserDeadlinesUseCase } from "../../application/deadline/GetUserDeadlinesUseCase";
import { CompleteDeadlineUseCase } from "../../application/deadline/CompleteDeadlineUseCase";
import { DeadlineService } from "../../domain/services/DeadlineService";
import { MockDeadlineRepository } from "../../infrastructure/database/memory/MockDeadlineRepository";
import type { IDeadlineRepository } from "../../domain/repositories/IDeadlineRepository";
import { writeRateLimiter } from "../../infrastructure/config/rateLimiter";
import { validate } from "../middleware/validationMiddleware";
import { createDeadlineSchema } from "../../domain/validation/deadlineSchemas";

export const deadlineRoutes = (repository: IDeadlineRepository) => {
  const router = Router();
  const service = new DeadlineService(repository);
  const controller = new DeadlineController(
    new CreateDeadlineUseCase(service),
    new GetUserDeadlinesUseCase(service),
    new CompleteDeadlineUseCase(service),
    repository as any
  );

  router.get("/", controller.getDeadlines);
  router.post("/", writeRateLimiter, validate(createDeadlineSchema), controller.createDeadline);
  router.patch("/:deadlineId/complete", writeRateLimiter, controller.completeDeadline);

  return router;
};
