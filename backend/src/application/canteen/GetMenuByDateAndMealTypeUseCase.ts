import { Result } from "../../shared/Result";
import { CanteenMenu, MealType, PostgresCanteenMenuRepository } from "../../infrastructure/database/postgres/PostgresCanteenMenuRepository";

export class GetMenuByDateAndMealTypeUseCase {
  constructor(private canteenMenuRepository: PostgresCanteenMenuRepository) {}

  async execute(date: Date, mealType: MealType): Promise<Result<CanteenMenu | null>> {
    return await this.canteenMenuRepository.getByDateAndMealType(date, mealType);
  }
}
