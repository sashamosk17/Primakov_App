import { Result } from "../../shared/Result";
import { Request, PostgresRequestRepository } from "../../infrastructure/database/postgres/PostgresRequestRepository";

export class CreateRequestUseCase {
  constructor(private requestRepository: PostgresRequestRepository) {}

  async execute(request: Request): Promise<Result<void>> {
    return await this.requestRepository.save(request);
  }
}
