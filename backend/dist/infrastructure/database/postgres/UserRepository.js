"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.UserRepository = void 0;
const Result_1 = require("../../../shared/Result");
class UserRepository {
    async findById(_id) {
        return Result_1.Result.fail("Not implemented");
    }
    async findByEmail(_email) {
        return Result_1.Result.fail("Not implemented");
    }
    async save(_user) {
        return Result_1.Result.fail("Not implemented");
    }
}
exports.UserRepository = UserRepository;
