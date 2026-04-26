import { Result } from "../../shared/Result";
import { Request, PostgresRequestRepository } from "../../infrastructure/database/postgres/PostgresRequestRepository";

export class GetActiveRequestsUseCase {
  constructor(private requestRepository: PostgresRequestRepository) {}

  async execute(): Promise<Result<Request[]>> {
    return await this.requestRepository.getActive();
  }
}
