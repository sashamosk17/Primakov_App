import { IScheduleRepository } from "../../../domain/repositories/IScheduleRepository";
import { Result } from "../../../shared/Result";
import { Schedule } from "../../../domain/entities/Schedule";

export class ScheduleRepository implements IScheduleRepository {
  async getScheduleByGroup(_groupId: string): Promise<Result<Schedule | null>> {
    return Result.fail("Not implemented");
  }

  async getScheduleByDate(_groupId: string, _date: Date): Promise<Result<Schedule | null>> {
    return Result.fail("Not implemented");
  }

  async save(_schedule: Schedule): Promise<Result<void>> {
    return Result.fail("Not implemented");
  }
}
