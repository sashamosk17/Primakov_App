import { Result } from "../../shared/Result";
import { Request, PostgresRequestRepository } from "../../infrastructure/database/postgres/PostgresRequestRepository";

export class UpdateRequestStatusUseCase {
  constructor(private requestRepository: PostgresRequestRepository) {}

  async execute(request: Request): Promise<Result<void>> {
    return await this.requestRepository.update(request);
  }
}
