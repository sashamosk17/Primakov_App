"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ScheduleController = void 0;
async function serializeSchedule(schedule, userRepository) {
    if (!schedule)
        return null;
    // Получаем всех учителей для уроков
    const teacherIds = [...new Set(schedule.lessons.map(l => l.teacherId))];
    const teachersMap = new Map();
    for (const teacherId of teacherIds) {
        const result = await userRepository.findById(teacherId);
        if (result.isSuccess && result.value) {
            teachersMap.set(teacherId, {
                firstName: result.value.firstName,
                lastName: result.value.lastName,
            });
        }
    }
    return {
        id: schedule.id,
        groupId: schedule.groupId,
        date: schedule.date.toISOString().split("T")[0],
        lessons: schedule.lessons.map((lesson) => {
            const teacher = teachersMap.get(lesson.teacherId);
            return {
                id: lesson.id,
                subject: lesson.subject,
                teacherId: lesson.teacherId,
                teacherName: teacher ? `${teacher.firstName} ${teacher.lastName}` : undefined,
                startTime: lesson.timeSlot.startTime,
                endTime: lesson.timeSlot.endTime,
                room: lesson.room.number,
                floor: lesson.floor,
                hasHomework: lesson.hasHomework,
                homeworkDescription: lesson.homeworkDescription,
            };
        }),
    };
}
class ScheduleController {
    constructor(getScheduleUseCase, getScheduleByDateUseCase, getScheduleByUserIdUseCase, userRepository) {
        this.getScheduleUseCase = getScheduleUseCase;
        this.getScheduleByDateUseCase = getScheduleByDateUseCase;
        this.getScheduleByUserIdUseCase = getScheduleByUserIdUseCase;
        this.userRepository = userRepository;
        this.getSchedule = async (req, res, next) => {
            try {
                const { groupId } = req.params;
                const result = await this.getScheduleUseCase.execute(groupId);
                if (result.isFailure) {
                    return res.status(400).json({
                        status: "error",
                        error: { message: result.error }
                    });
                }
                const serialized = await serializeSchedule(result.value, this.userRepository);
                return res.json({ status: "success", data: serialized });
            }
            catch (error) {
                return next(error);
            }
        };
        this.getScheduleByDate = async (req, res, next) => {
            try {
                const { groupId, date } = req.params;
                const result = await this.getScheduleByDateUseCase.execute(groupId, new Date(date));
                if (result.isFailure) {
                    return res.status(400).json({
                        status: "error",
                        error: { message: result.error }
                    });
                }
                const serialized = await serializeSchedule(result.value, this.userRepository);
                return res.json({ status: "success", data: serialized });
            }
            catch (error) {
                return next(error);
            }
        };
        this.getScheduleByUserId = async (req, res, next) => {
            try {
                const { userId, date } = req.params;
                const result = await this.getScheduleByUserIdUseCase.execute(userId, new Date(date));
                if (result.isFailure) {
                    return res.status(400).json({
                        status: "error",
                        error: { message: result.error }
                    });
                }
                const serialized = await serializeSchedule(result.value, this.userRepository);
                return res.json({ status: "success", data: serialized });
            }
            catch (error) {
                return next(error);
            }
        };
    }
}
exports.ScheduleController = ScheduleController;
