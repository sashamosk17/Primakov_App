import { Result } from "../../shared/Result";
import { Request, PostgresRequestRepository } from "../../infrastructure/database/postgres/PostgresRequestRepository";

export class GetAssignedRequestsUseCase {
  constructor(private requestRepository: PostgresRequestRepository) {}

  async execute(assigneeId: string): Promise<Result<Request[]>> {
    return await this.requestRepository.getByAssignee(assigneeId);
  }
}
