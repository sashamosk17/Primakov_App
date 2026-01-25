import { IRatingRepository } from "../../../domain/repositories/IRatingRepository";
import { Result } from "../../../shared/Result";
import { Rating } from "../../../domain/entities/Rating";

export class RatingRepository implements IRatingRepository {
  async getByTeacher(_teacherId: string): Promise<Result<Rating[]>> {
    return Result.fail("Not implemented");
  }

  async save(_rating: Rating): Promise<Result<void>> {
    return Result.fail("Not implemented");
  }

  async update(_rating: Rating): Promise<Result<void>> {
    return Result.fail("Not implemented");
  }
}
