import { Request, Response, NextFunction } from "express";
import { GetScheduleUseCase } from "../../application/schedule/GetScheduleUseCase";
import { GetScheduleByDateUseCase } from "../../application/schedule/GetScheduleByDateUseCase";

export class ScheduleController {
  constructor(
    private readonly getScheduleUseCase: GetScheduleUseCase,
    private readonly getScheduleByDateUseCase: GetScheduleByDateUseCase
  ) {}

  public getSchedule = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { groupId } = req.params;
      const result = await this.getScheduleUseCase.execute(groupId);
      return res.json({ status: "success", data: result.value });
    } catch (error) {
      return next(error);
    }
  };

  public getScheduleByDate = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { groupId, date } = req.params;
      const result = await this.getScheduleByDateUseCase.execute(groupId, new Date(date));
      return res.json({ status: "success", data: result.value });
    } catch (error) {
      return next(error);
    }
  };
}
