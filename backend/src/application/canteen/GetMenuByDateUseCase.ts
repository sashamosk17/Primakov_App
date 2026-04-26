import { Result } from "../../shared/Result";
import { CanteenMenu, PostgresCanteenMenuRepository } from "../../infrastructure/database/postgres/PostgresCanteenMenuRepository";

export class GetMenuByDateUseCase {
  constructor(private canteenMenuRepository: PostgresCanteenMenuRepository) {}

  async execute(date: Date): Promise<Result<CanteenMenu[]>> {
    return await this.canteenMenuRepository.getByDate(date);
  }
}
