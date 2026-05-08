"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.GetMenuByDateUseCase = void 0;
class GetMenuByDateUseCase {
    constructor(canteenMenuRepository) {
        this.canteenMenuRepository = canteenMenuRepository;
    }
    async execute(date) {
        return await this.canteenMenuRepository.getByDate(date);
    }
}
exports.GetMenuByDateUseCase = GetMenuByDateUseCase;
