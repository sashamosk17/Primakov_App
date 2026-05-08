"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.DeadlineController = void 0;
const crypto_1 = require("crypto");
const Deadline_1 = require("../../domain/entities/Deadline");
const DeadlineStatus_1 = require("../../domain/value-objects/DeadlineStatus");
class DeadlineController {
    constructor(createDeadlineUseCase, getUserDeadlinesUseCase, completeDeadlineUseCase, deadlineRepository) {
        this.createDeadlineUseCase = createDeadlineUseCase;
        this.getUserDeadlinesUseCase = getUserDeadlinesUseCase;
        this.completeDeadlineUseCase = completeDeadlineUseCase;
        this.deadlineRepository = deadlineRepository;
        this.getDeadlines = async (req, res, next) => {
            try {
                // Получаем userId либо из токена, либо из query параметров
                const userId = req.user?.userId || req.query.userId || "user-1";
                const result = await this.getUserDeadlinesUseCase.execute(userId);
                return res.json({ status: "success", data: result.value });
            }
            catch (error) {
                return next(error);
            }
        };
        this.createDeadline = async (req, res, next) => {
            try {
                const userId = req.user?.userId || req.body.userId || "user-1";
                const { title, description, dueDate, subject } = req.body;
                const deadline = new Deadline_1.Deadline((0, crypto_1.randomUUID)(), title, description, new Date(dueDate), userId, DeadlineStatus_1.DeadlineStatus.PENDING, new Date(), undefined, undefined, subject);
                const result = await this.createDeadlineUseCase.execute(deadline);
                if (result.isFailure) {
                    return res.status(400).json({ status: "error", error: { message: result.error } });
                }
                return res.status(201).json({ status: "success", data: deadline });
            }
            catch (error) {
                return next(error);
            }
        };
        this.completeDeadline = async (req, res, next) => {
            try {
                const { deadlineId } = req.params;
                const deadline = await this.deadlineRepository.findById(deadlineId);
                if (!deadline) {
                    return res.status(404).json({ status: "error", error: { message: "Deadline not found" } });
                }
                const completeResult = deadline.status === DeadlineStatus_1.DeadlineStatus.COMPLETED
                    ? deadline.uncomplete()
                    : deadline.complete();
                if (completeResult.isFailure) {
                    return res.status(400).json({ status: "error", error: { message: completeResult.error } });
                }
                const result = await this.completeDeadlineUseCase.execute(deadline);
                if (result.isFailure) {
                    return res.status(400).json({ status: "error", error: { message: result.error } });
                }
                return res.json({ status: "success", data: deadline });
            }
            catch (error) {
                return next(error);
            }
        };
    }
}
exports.DeadlineController = DeadlineController;
