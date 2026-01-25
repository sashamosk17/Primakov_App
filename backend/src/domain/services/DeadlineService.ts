import { IDeadlineRepository } from "../repositories/IDeadlineRepository";
import { Deadline } from "../entities/Deadline";
import { Result } from "../../shared/Result";

export class DeadlineService {
  constructor(private readonly deadlineRepository: IDeadlineRepository) {}

  public async getUserDeadlines(userId: string): Promise<Result<Deadline[]>> {
    return this.deadlineRepository.getByUser(userId);
  }

  public async create(deadline: Deadline): Promise<Result<void>> {
    return this.deadlineRepository.save(deadline);
  }

  public async complete(deadline: Deadline): Promise<Result<void>> {
    return this.deadlineRepository.update(deadline);
  }
}
