import { Deadline } from "../entities/Deadline";
import { Result } from "../../shared/Result";

export interface IDeadlineRepository {
  getByUser(userId: string): Promise<Result<Deadline[]>>;
  save(deadline: Deadline): Promise<Result<void>>;
  update(deadline: Deadline): Promise<Result<void>>;
}
