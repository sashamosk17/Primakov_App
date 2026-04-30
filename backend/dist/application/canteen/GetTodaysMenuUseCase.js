"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.GetTodaysMenuUseCase = void 0;
const Result_1 = require("../../shared/Result");
class GetTodaysMenuUseCase {
    constructor(canteenMenuRepository) {
        this.canteenMenuRepository = canteenMenuRepository;
    }
    async execute() {
        const result = await this.canteenMenuRepository.getTodaysMenu();
        if (result.isFailure) {
            return Result_1.Result.fail(result.error || "Unknown error");
        }
        const menus = result.value;
        if (menus.length === 0) {
            return Result_1.Result.fail("No menu available for today");
        }
        // Combine all menus into a single menu with all items
        const allItems = menus.flatMap(menu => menu.items);
        const combinedMenu = {
            id: menus[0].id,
            date: menus[0].date,
            mealType: 'LUNCH', // Default, not used by Flutter
            isActive: true,
            items: allItems,
            createdAt: menus[0].createdAt,
            updatedAt: new Date(),
        };
        return Result_1.Result.ok(combinedMenu);
    }
}
exports.GetTodaysMenuUseCase = GetTodaysMenuUseCase;
