"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ScheduleController = void 0;
class ScheduleController {
    constructor(getScheduleUseCase, getScheduleByDateUseCase) {
        this.getScheduleUseCase = getScheduleUseCase;
        this.getScheduleByDateUseCase = getScheduleByDateUseCase;
        this.getSchedule = async (req, res, next) => {
            try {
                const { groupId } = req.params;
                const result = await this.getScheduleUseCase.execute(groupId);
                return res.json({ status: "success", data: result.value });
            }
            catch (error) {
                return next(error);
            }
        };
        this.getScheduleByDate = async (req, res, next) => {
            try {
                const { groupId, date } = req.params;
                const result = await this.getScheduleByDateUseCase.execute(groupId, new Date(date));
                return res.json({ status: "success", data: result.value });
            }
            catch (error) {
                return next(error);
            }
        };
    }
}
exports.ScheduleController = ScheduleController;
