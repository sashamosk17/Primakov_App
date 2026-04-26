import { Result } from "../../shared/Result";
import { Request, PostgresRequestRepository } from "../../infrastructure/database/postgres/PostgresRequestRepository";

export class GetUserRequestsUseCase {
  constructor(private requestRepository: PostgresRequestRepository) {}

  async execute(userId: string): Promise<Result<Request[]>> {
    return await this.requestRepository.getByCreator(userId);
  }
}
