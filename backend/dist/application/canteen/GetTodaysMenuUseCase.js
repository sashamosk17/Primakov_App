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
        // Return empty array if no menu available - this is a valid state
        if (menus.length === 0) {
            return Result_1.Result.ok([]);
        }
        return Result_1.Result.ok(menus);
    }
}
exports.GetTodaysMenuUseCase = GetTodaysMenuUseCase;
