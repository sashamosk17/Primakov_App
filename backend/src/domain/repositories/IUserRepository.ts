import { User } from "../entities/User";
import { Result } from "../../shared/Result";

export interface IUserRepository {
  findById(id: string): Promise<Result<User | null>>;
  findByEmail(email: string): Promise<Result<User | null>>;
  save(user: User): Promise<Result<void>>;
}
