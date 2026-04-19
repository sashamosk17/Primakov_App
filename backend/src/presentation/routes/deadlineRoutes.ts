import { Router } from "express";
import { DeadlineController } from "../controllers/DeadlineController";
import { CreateDeadlineUseCase } from "../../application/deadline/CreateDeadlineUseCase";
import { GetUserDeadlinesUseCase } from "../../application/deadline/GetUserDeadlinesUseCase";
import { CompleteDeadlineUseCase } from "../../application/deadline/CompleteDeadlineUseCase";
import { DeadlineService } from "../../domain/services/DeadlineService";
import { MockDeadlineRepository } from "../../infrastructure/database/memory/MockDeadlineRepository";
import type { IDeadlineRepository } from "../../domain/repositories/IDeadlineRepository";

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
  router.post("/", controller.createDeadline);
  router.patch("/:deadlineId/complete", controller.completeDeadline);

  return router;
};
