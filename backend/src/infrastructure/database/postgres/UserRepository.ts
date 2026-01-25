import { IUserRepository } from "../../../domain/repositories/IUserRepository";
import { Result } from "../../../shared/Result";
import { User } from "../../../domain/entities/User";

export class UserRepository implements IUserRepository {
  async findById(_id: string): Promise<Result<User | null>> {
    return Result.fail("Not implemented");
  }

  async findByEmail(_email: string): Promise<Result<User | null>> {
    return Result.fail("Not implemented");
  }

  async save(_user: User): Promise<Result<void>> {
    return Result.fail("Not implemented");
  }
}
