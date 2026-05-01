"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ScheduleController = void 0;
function serializeSchedule(schedule) {
    if (!schedule)
        return null;
    return {
        id: schedule.id,
        groupId: schedule.groupId,
        date: schedule.date.toISOString().split("T")[0],
        lessons: schedule.lessons.map((lesson) => ({
            id: lesson.id,
            subject: lesson.subject,
            teacherId: lesson.teacherId,
            startTime: lesson.timeSlot.startTime,
            endTime: lesson.timeSlot.endTime,
            room: lesson.room.number,
            floor: lesson.floor,
            hasHomework: lesson.hasHomework,
        })),
    };
}
class ScheduleController {
    constructor(getScheduleUseCase, getScheduleByDateUseCase, getScheduleByUserIdUseCase) {
        this.getScheduleUseCase = getScheduleUseCase;
        this.getScheduleByDateUseCase = getScheduleByDateUseCase;
        this.getScheduleByUserIdUseCase = getScheduleByUserIdUseCase;
        this.getSchedule = async (req, res, next) => {
            try {
                const { groupId } = req.params;
                const result = await this.getScheduleUseCase.execute(groupId);
                return res.json({ status: "success", data: serializeSchedule(result.value) });
            }
            catch (error) {
                return next(error);
            }
        };
        this.getScheduleByDate = async (req, res, next) => {
            try {
                const { groupId, date } = req.params;
                const result = await this.getScheduleByDateUseCase.execute(groupId, new Date(date));
                return res.json({ status: "success", data: serializeSchedule(result.value) });
            }
            catch (error) {
                return next(error);
            }
        };
        this.getScheduleByUserId = async (req, res, next) => {
            try {
                const { userId, date } = req.params;
                const result = await this.getScheduleByUserIdUseCase.execute(userId, new Date(date));
                return res.json({ status: "success", data: serializeSchedule(result.value) });
            }
            catch (error) {
                return next(error);
            }
        };
    }
}
exports.ScheduleController = ScheduleController;
