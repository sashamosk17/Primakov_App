import { DeadlineService } from "../../domain/services/DeadlineService";
import { Deadline } from "../../domain/entities/Deadline";

export class CompleteDeadlineUseCase {
  constructor(private readonly deadlineService: DeadlineService) {}

  public async execute(deadline: Deadline) {
    return this.deadlineService.complete(deadline);
  }
}
