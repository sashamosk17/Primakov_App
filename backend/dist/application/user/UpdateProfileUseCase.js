"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.UpdateProfileUseCase = void 0;
const Result_1 = require("../../shared/Result");
class UpdateProfileUseCase {
    constructor(userRepository) {
        this.userRepository = userRepository;
    }
    async execute(input) {
        const { userId, firstName, lastName } = input;
        // Проверяем что хотя бы одно поле передано
        if (firstName === undefined && lastName === undefined) {
            return Result_1.Result.fail("At least one field (firstName or lastName) must be provided");
        }
        // Валидация firstName
        if (firstName !== undefined) {
            const trimmed = firstName.trim();
            if (trimmed.length === 0)
                return Result_1.Result.fail("First name cannot be empty");
            if (trimmed.length > 50)
                return Result_1.Result.fail("First name must not exceed 50 characters");
        }
        // Валидация lastName
        if (lastName !== undefined) {
            const trimmed = lastName.trim();
            if (trimmed.length === 0)
                return Result_1.Result.fail("Last name cannot be empty");
            if (trimmed.length > 50)
                return Result_1.Result.fail("Last name must not exceed 50 characters");
        }
        // Загружаем пользователя
        const userResult = await this.userRepository.findById(userId);
        if (userResult.isFailure) {
            return Result_1.Result.fail(userResult.error);
        }
        if (!userResult.value) {
            return Result_1.Result.fail("User not found");
        }
        const user = userResult.value;
        // Domain-метод выполняет обновление
        user.updateProfile(firstName?.trim(), lastName?.trim());
        // Сохраняем через существующий upsert-метод
        const saveResult = await this.userRepository.save(user);
        if (saveResult.isFailure) {
            return Result_1.Result.fail(saveResult.error);
        }
        return Result_1.Result.ok(user);
    }
}
exports.UpdateProfileUseCase = UpdateProfileUseCase;
