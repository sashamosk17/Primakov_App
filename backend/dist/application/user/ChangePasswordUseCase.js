"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ChangePasswordUseCase = void 0;
const Password_1 = require("../../domain/value-objects/Password");
const Result_1 = require("../../shared/Result");
const MIN_PASSWORD_LENGTH = 8;
const MAX_PASSWORD_LENGTH = 100;
class ChangePasswordUseCase {
    constructor(userRepository) {
        this.userRepository = userRepository;
    }
    async execute(input) {
        const { userId, currentPassword, newPassword } = input;
        // Валидация нового пароля (Password.create() не валидирует — делаем здесь)
        if (newPassword.length < MIN_PASSWORD_LENGTH) {
            return Result_1.Result.fail(`New password must be at least ${MIN_PASSWORD_LENGTH} characters`);
        }
        if (newPassword.length > MAX_PASSWORD_LENGTH) {
            return Result_1.Result.fail("New password is too long");
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
        // Проверяем текущий пароль через User.verify() (использует bcrypt compareSync)
        if (!user.verify(currentPassword)) {
            return Result_1.Result.fail("Current password is incorrect");
        }
        // Запрещаем установку того же пароля
        if (user.verify(newPassword)) {
            return Result_1.Result.fail("New password must be different from the current password");
        }
        // Создаём новый хеш и обновляем через domain-метод
        user.changePassword(Password_1.Password.create(newPassword));
        // Сохраняем — PostgresUserRepository.save() обновляет password_hash
        const saveResult = await this.userRepository.save(user);
        if (saveResult.isFailure) {
            return Result_1.Result.fail(saveResult.error);
        }
        return Result_1.Result.ok();
    }
}
exports.ChangePasswordUseCase = ChangePasswordUseCase;
