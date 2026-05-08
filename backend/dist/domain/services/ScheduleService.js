"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ScheduleService = void 0;
class ScheduleService {
    constructor(scheduleRepository) {
        this.scheduleRepository = scheduleRepository;
    }
    async getSchedule(groupId) {
        return this.scheduleRepository.getScheduleByGroup(groupId);
    }
    async getScheduleByDate(groupId, date) {
        return this.scheduleRepository.getScheduleByDate(groupId, date);
    }
    async getScheduleByUserId(userId, date) {
        return this.scheduleRepository.getScheduleByUserId(userId, date);
    }
}
exports.ScheduleService = ScheduleService;
