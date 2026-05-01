import { Result } from "../../shared/Result";
import { CanteenMenu, PostgresCanteenMenuRepository } from "../../infrastructure/database/postgres/PostgresCanteenMenuRepository";

export class GetTodaysMenuUseCase {
  constructor(private canteenMenuRepository: PostgresCanteenMenuRepository) {}

  async execute(): Promise<Result<CanteenMenu[]>> {
    const result = await this.canteenMenuRepository.getTodaysMenu();

    if (result.isFailure) {
      return Result.fail(result.error || "Unknown error");
    }

    const menus = result.value;

    // Return empty array if no menu available - this is a valid state
    if (menus.length === 0) {
      return Result.ok([]);
    }

    return Result.ok(menus);
  }
}
