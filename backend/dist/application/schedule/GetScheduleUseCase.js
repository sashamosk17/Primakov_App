"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.GetScheduleUseCase = void 0;
class GetScheduleUseCase {
    constructor(scheduleService) {
        this.scheduleService = scheduleService;
    }
    async execute(groupId) {
        return this.scheduleService.getSchedule(groupId);
    }
}
exports.GetScheduleUseCase = GetScheduleUseCase;
