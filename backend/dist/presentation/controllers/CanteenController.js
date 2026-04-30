"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.CanteenController = void 0;
const GetTodaysMenuUseCase_1 = require("../../application/canteen/GetTodaysMenuUseCase");
const GetMenuByDateUseCase_1 = require("../../application/canteen/GetMenuByDateUseCase");
const GetMenuByDateAndMealTypeUseCase_1 = require("../../application/canteen/GetMenuByDateAndMealTypeUseCase");
class CanteenController {
    constructor(repository) {
        this.repository = repository;
        this.getTodaysMenu = async (req, res) => {
            const useCase = new GetTodaysMenuUseCase_1.GetTodaysMenuUseCase(this.repository);
            const result = await useCase.execute();
            if (result.isFailure) {
                return res.status(400).json({
                    status: "error",
                    error: { message: result.error },
                });
            }
            return res.json({
                status: "success",
                data: result.value,
            });
        };
        this.getMenuByDate = async (req, res) => {
            const { date } = req.params;
            const parsedDate = new Date(date);
            if (isNaN(parsedDate.getTime())) {
                return res.status(400).json({
                    status: "error",
                    error: { message: "Invalid date format" },
                });
            }
            const useCase = new GetMenuByDateUseCase_1.GetMenuByDateUseCase(this.repository);
            const result = await useCase.execute(parsedDate);
            if (result.isFailure) {
                return res.status(400).json({
                    status: "error",
                    error: { message: result.error },
                });
            }
            return res.json({
                status: "success",
                data: result.value,
            });
        };
        this.getMenuByDateAndMealType = async (req, res) => {
            const { date, mealType } = req.params;
            const parsedDate = new Date(date);
            if (isNaN(parsedDate.getTime())) {
                return res.status(400).json({
                    status: "error",
                    error: { message: "Invalid date format" },
                });
            }
            const mealTypeUpper = mealType.toUpperCase();
            if (!["BREAKFAST", "LUNCH", "DINNER", "SNACK"].includes(mealTypeUpper)) {
                return res.status(400).json({
                    status: "error",
                    error: { message: "Invalid meal type" },
                });
            }
            const useCase = new GetMenuByDateAndMealTypeUseCase_1.GetMenuByDateAndMealTypeUseCase(this.repository);
            const result = await useCase.execute(parsedDate, mealTypeUpper);
            if (result.isFailure) {
                return res.status(400).json({
                    status: "error",
                    error: { message: result.error },
                });
            }
            if (!result.value) {
                return res.status(404).json({
                    status: "error",
                    error: { message: "Menu not found" },
                });
            }
            return res.json({
                status: "success",
                data: result.value,
            });
        };
    }
}
exports.CanteenController = CanteenController;
