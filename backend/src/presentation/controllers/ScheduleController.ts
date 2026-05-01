import { Request, Response, NextFunction } from "express";
import { GetScheduleUseCase } from "../../application/schedule/GetScheduleUseCase";
import { GetScheduleByDateUseCase } from "../../application/schedule/GetScheduleByDateUseCase";
import { GetScheduleByUserIdUseCase } from "../../application/schedule/GetScheduleByUserIdUseCase";
import { Schedule } from "../../domain/entities/Schedule";

function serializeSchedule(schedule: Schedule | null) {
  if (!schedule) return null;
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

export class ScheduleController {
  constructor(
    private readonly getScheduleUseCase: GetScheduleUseCase,
    private readonly getScheduleByDateUseCase: GetScheduleByDateUseCase,
    private readonly getScheduleByUserIdUseCase: GetScheduleByUserIdUseCase
  ) {}

  public getSchedule = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { groupId } = req.params;
      const result = await this.getScheduleUseCase.execute(groupId);
      return res.json({ status: "success", data: serializeSchedule(result.value) });
    } catch (error) {
      return next(error);
    }
  };

  public getScheduleByDate = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { groupId, date } = req.params;
      const result = await this.getScheduleByDateUseCase.execute(groupId, new Date(date));
      return res.json({ status: "success", data: serializeSchedule(result.value) });
    } catch (error) {
      return next(error);
    }
  };

  public getScheduleByUserId = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { userId, date } = req.params;
      const result = await this.getScheduleByUserIdUseCase.execute(userId, new Date(date));
      return res.json({ status: "success", data: serializeSchedule(result.value) });
    } catch (error) {
      return next(error);
    }
  };
}
