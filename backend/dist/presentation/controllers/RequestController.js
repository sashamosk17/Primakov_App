"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.RequestController = void 0;
const CreateRequestUseCase_1 = require("../../application/request/CreateRequestUseCase");
const GetUserRequestsUseCase_1 = require("../../application/request/GetUserRequestsUseCase");
const GetAssignedRequestsUseCase_1 = require("../../application/request/GetAssignedRequestsUseCase");
const UpdateRequestStatusUseCase_1 = require("../../application/request/UpdateRequestStatusUseCase");
const GetActiveRequestsUseCase_1 = require("../../application/request/GetActiveRequestsUseCase");
const GetRequestsByTypeUseCase_1 = require("../../application/request/GetRequestsByTypeUseCase");
class RequestController {
    constructor(repository) {
        this.repository = repository;
        this.create = async (req, res) => {
            const useCase = new CreateRequestUseCase_1.CreateRequestUseCase(this.repository);
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
        this.getUserRequests = async (req, res) => {
            const userId = req.user?.id;
            if (!userId) {
                return res.status(401).json({
                    status: "error",
                    error: { message: "Unauthorized" },
                });
            }
            const useCase = new GetUserRequestsUseCase_1.GetUserRequestsUseCase(this.repository);
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
        this.getAssignedRequests = async (req, res) => {
            const assigneeId = req.user?.id;
            if (!assigneeId) {
                return res.status(401).json({
                    status: "error",
                    error: { message: "Unauthorized" },
                });
            }
            const useCase = new GetAssignedRequestsUseCase_1.GetAssignedRequestsUseCase(this.repository);
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
        this.updateStatus = async (req, res) => {
            const { id } = req.params;
            const requestData = req.body;
            const useCase = new UpdateRequestStatusUseCase_1.UpdateRequestStatusUseCase(this.repository);
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
        this.getActive = async (req, res) => {
            const useCase = new GetActiveRequestsUseCase_1.GetActiveRequestsUseCase(this.repository);
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
        this.getByType = async (req, res) => {
            const { type } = req.params;
            const requestType = type.toUpperCase();
            if (!["IT", "MAINTENANCE", "CLEANING"].includes(requestType)) {
                return res.status(400).json({
                    status: "error",
                    error: { message: "Invalid request type" },
                });
            }
            const useCase = new GetRequestsByTypeUseCase_1.GetRequestsByTypeUseCase(this.repository);
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
}
exports.RequestController = RequestController;
