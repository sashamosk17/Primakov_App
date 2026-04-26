import { Result } from "../../shared/Result";
import { Request, RequestType, PostgresRequestRepository } from "../../infrastructure/database/postgres/PostgresRequestRepository";

export class GetRequestsByTypeUseCase {
  constructor(private requestRepository: PostgresRequestRepository) {}

  async execute(type: RequestType): Promise<Result<Request[]>> {
    return await this.requestRepository.getByType(type);
  }
}
