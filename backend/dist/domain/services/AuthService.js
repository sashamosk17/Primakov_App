"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.AuthService = void 0;
const crypto_1 = require("crypto");
const Email_1 = require("../value-objects/Email");
const Password_1 = require("../value-objects/Password");
const Result_1 = require("../../shared/Result");
const User_1 = require("../entities/User");
const jwt_1 = require("../../shared/utils/jwt");
const constants_1 = require("../../shared/constants");
class AuthService {
    constructor(userRepository) {
        this.userRepository = userRepository;
    }
    async register(email, password) {
        const existing = await this.userRepository.findByEmail(email);
        if (existing.isSuccess && existing.value) {
            return Result_1.Result.fail("User already exists");
        }
        const emailResult = Email_1.Email.create(email);
        if (emailResult.isFailure) {
            return Result_1.Result.fail(emailResult.error);
        }
        const user = new User_1.User((0, crypto_1.randomUUID)(), emailResult.value, Password_1.Password.create(password), "", "", "STUDENT", new Date());
        const saveResult = await this.userRepository.save(user);
        if (saveResult.isFailure) {
            return Result_1.Result.fail(saveResult.error);
        }
        const token = (0, jwt_1.signToken)({
            userId: user.id,
            role: user.role,
            permissions: constants_1.ROLE_PERMISSIONS[user.role]
        });
        return Result_1.Result.ok({ user, token });
    }
    async login(email, password) {
        const userResult = await this.userRepository.findByEmail(email);
        if (userResult.isFailure || !userResult.value) {
            return Result_1.Result.fail("Invalid credentials");
        }
        const user = userResult.value;
        if (!user.verify(password)) {
            return Result_1.Result.fail("Invalid credentials");
        }
        user.updateLastLogin();
        const token = (0, jwt_1.signToken)({
            userId: user.id,
            role: user.role,
            permissions: constants_1.ROLE_PERMISSIONS[user.role]
        });
        return Result_1.Result.ok({ user, token });
    }
}
exports.AuthService = AuthService;
