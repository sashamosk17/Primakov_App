"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.DeadlineController = void 0;
const crypto_1 = require("crypto");
const Deadline_1 = require("../../domain/entities/Deadline");
const DeadlineStatus_1 = require("../../domain/value-objects/DeadlineStatus");
class DeadlineController {
    constructor(createDeadlineUseCase, getUserDeadlinesUseCase) {
        this.createDeadlineUseCase = createDeadlineUseCase;
        this.getUserDeadlinesUseCase = getUserDeadlinesUseCase;
        this.getDeadlines = async (req, res, next) => {
            try {
                const userId = req.user?.userId || "";
                const result = await this.getUserDeadlinesUseCase.execute(userId);
                return res.json({ status: "success", data: result.value });
            }
            catch (error) {
                return next(error);
            }
        };
        this.createDeadline = async (req, res, next) => {
            try {
                const userId = req.user?.userId || "";
                const { title, description, dueDate, subject } = req.body;
                const deadline = new Deadline_1.Deadline((0, crypto_1.randomUUID)(), title, description, new Date(dueDate), userId, DeadlineStatus_1.DeadlineStatus.PENDING, new Date(), undefined, undefined, subject);
                const result = await this.createDeadlineUseCase.execute(deadline);
                if (result.isFailure) {
                    return res.status(400).json({ status: "error", error: { message: result.error } });
                }
                return res.status(201).json({ status: "success" });
            }
            catch (error) {
                return next(error);
            }
        };
    }
}
exports.DeadlineController = DeadlineController;
