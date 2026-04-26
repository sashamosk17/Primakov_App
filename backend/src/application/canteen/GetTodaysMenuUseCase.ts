import { Result } from "../../shared/Result";
import { CanteenMenu, PostgresCanteenMenuRepository } from "../../infrastructure/database/postgres/PostgresCanteenMenuRepository";

export class GetTodaysMenuUseCase {
  constructor(private canteenMenuRepository: PostgresCanteenMenuRepository) {}

  async execute(): Promise<Result<CanteenMenu>> {
    const result = await this.canteenMenuRepository.getTodaysMenu();

    if (result.isFailure) {
      return Result.fail(result.error);
    }

    const menus = result.value;

    if (menus.length === 0) {
      return Result.fail("No menu available for today");
    }

    // Combine all menus into a single menu with all items
    const allItems = menus.flatMap(menu => menu.items);

    const combinedMenu: CanteenMenu = {
      id: menus[0].id,
      date: menus[0].date,
      mealType: 'LUNCH', // Default, not used by Flutter
      isActive: true,
      items: allItems,
      createdAt: menus[0].createdAt,
      updatedAt: new Date(),
    };

    return Result.ok(combinedMenu);
  }
}
