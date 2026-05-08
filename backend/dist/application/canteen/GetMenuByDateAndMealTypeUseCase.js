"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.GetMenuByDateAndMealTypeUseCase = void 0;
class GetMenuByDateAndMealTypeUseCase {
    constructor(canteenMenuRepository) {
        this.canteenMenuRepository = canteenMenuRepository;
    }
    async execute(date, mealType) {
        return await this.canteenMenuRepository.getByDateAndMealType(date, mealType);
    }
}
exports.GetMenuByDateAndMealTypeUseCase = GetMenuByDateAndMealTypeUseCase;
