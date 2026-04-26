import { Request, Response } from "express";
import { PostgresRequestRepository, RequestType } from "../../infrastructure/database/postgres/PostgresRequestRepository";
import { CreateRequestUseCase } from "../../application/request/CreateRequestUseCase";
import { GetUserRequestsUseCase } from "../../application/request/GetUserRequestsUseCase";
import { GetAssignedRequestsUseCase } from "../../application/request/GetAssignedRequestsUseCase";
import { UpdateRequestStatusUseCase } from "../../application/request/UpdateRequestStatusUseCase";
import { GetActiveRequestsUseCase } from "../../application/request/GetActiveRequestsUseCase";
import { GetRequestsByTypeUseCase } from "../../application/request/GetRequestsByTypeUseCase";

export class RequestController {
  constructor(private repository: PostgresRequestRepository) {}

  create = async (req: Request, res: Response) => {
    const useCase = new CreateRequestUseCase(this.repository);
    const result = await useCase.execute(req.body);

    if (result.isFailure) {
      return res.status(400).json({
        status: "error",
        error: { message: result.error },
      });
    }

    return res.status(201).json({
      status: "success",
      data: { message: "Request created successfully" },
    });
  };

  getUserRequests = async (req: Request, res: Response) => {
    const userId = (req as any).user?.id;

    if (!userId) {
      return res.status(401).json({
        status: "error",
        error: { message: "Unauthorized" },
      });
    }

    const useCase = new GetUserRequestsUseCase(this.repository);
    const result = await useCase.execute(userId);

    if (result.isFailure) {
      return res.status(400).json({
        status: "error",
        error: { message: result.error },
      });
    }

    return res.json({
      status: "success",
      data: result.value,
    });
  };

  getAssignedRequests = async (req: Request, res: Response) => {
    const assigneeId = (req as any).user?.id;

    if (!assigneeId) {
      return res.status(401).json({
        status: "error",
        error: { message: "Unauthorized" },
      });
    }

    const useCase = new GetAssignedRequestsUseCase(this.repository);
    const result = await useCase.execute(assigneeId);

    if (result.isFailure) {
      return res.status(400).json({
        status: "error",
        error: { message: result.error },
      });
    }

    return res.json({
      status: "success",
      data: result.value,
    });
  };

  updateStatus = async (req: Request, res: Response) => {
    const { id } = req.params;
    const requestData = req.body;

    const useCase = new UpdateRequestStatusUseCase(this.repository);
    const result = await useCase.execute({ ...requestData, id });

    if (result.isFailure) {
      return res.status(400).json({
        status: "error",
        error: { message: result.error },
      });
    }

    return res.json({
      status: "success",
      data: { message: "Request updated successfully" },
    });
  };

  getActive = async (req: Request, res: Response) => {
    const useCase = new GetActiveRequestsUseCase(this.repository);
    const result = await useCase.execute();

    if (result.isFailure) {
      return res.status(400).json({
        status: "error",
        error: { message: result.error },
      });
    }

    return res.json({
      status: "success",
      data: result.value,
    });
  };

  getByType = async (req: Request, res: Response) => {
    const { type } = req.params;
    const requestType = type.toUpperCase() as RequestType;

    if (!["IT", "MAINTENANCE", "CLEANING"].includes(requestType)) {
      return res.status(400).json({
        status: "error",
        error: { message: "Invalid request type" },
      });
    }

    const useCase = new GetRequestsByTypeUseCase(this.repository);
    const result = await useCase.execute(requestType);

    if (result.isFailure) {
      return res.status(400).json({
        status: "error",
        error: { message: result.error },
      });
    }

    return res.json({
      status: "success",
      data: result.value,
    });
  };
}
