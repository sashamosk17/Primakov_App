import { IDeadlineRepository } from "../../../domain/repositories/IDeadlineRepository";
import { Result } from "../../../shared/Result";
import { Deadline } from "../../../domain/entities/Deadline";

export class DeadlineRepository implements IDeadlineRepository {
  async getByUser(_userId: string): Promise<Result<Deadline[]>> {
    return Result.fail("Not implemented");
  }

  async findById(_id: string): Promise<Deadline | undefined> {
    return undefined;
  }

  async save(_deadline: Deadline): Promise<Result<void>> {
    return Result.fail("Not implemented");
  }

  async update(_deadline: Deadline): Promise<Result<void>> {
    return Result.fail("Not implemented");
  }
}
