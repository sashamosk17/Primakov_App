"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.GetScheduleByUserIdUseCase = void 0;
class GetScheduleByUserIdUseCase {
    constructor(scheduleService) {
        this.scheduleService = scheduleService;
    }
    async execute(userId, date) {
        return this.scheduleService.getScheduleByUserId(userId, date);
    }
}
exports.GetScheduleByUserIdUseCase = GetScheduleByUserIdUseCase;
