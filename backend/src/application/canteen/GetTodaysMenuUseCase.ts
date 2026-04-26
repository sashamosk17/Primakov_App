import { Result } from "../../shared/Result";
import { CanteenMenu, PostgresCanteenMenuRepository } from "../../infrastructure/database/postgres/PostgresCanteenMenuRepository";

export class GetTodaysMenuUseCase {
  constructor(private canteenMenuRepository: PostgresCanteenMenuRepository) {}

  async execute(): Promise<Result<CanteenMenu[]>> {
    return await this.canteenMenuRepository.getTodaysMenu();
  }
}
