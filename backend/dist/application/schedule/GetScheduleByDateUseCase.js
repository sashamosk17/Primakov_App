"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.GetScheduleByDateUseCase = void 0;
class GetScheduleByDateUseCase {
    constructor(scheduleService) {
        this.scheduleService = scheduleService;
    }
    async execute(groupId, date) {
        return this.scheduleService.getScheduleByDate(groupId, date);
    }
}
exports.GetScheduleByDateUseCase = GetScheduleByDateUseCase;
