import { IRatingRepository } from "../../../domain/repositories/IRatingRepository";
import { Rating } from "../../../domain/entities/Rating";
import { Result } from "../../../shared/Result";

export class MockRatingRepository implements IRatingRepository {
  private ratings: Rating[] = [];

  async getByTeacher(teacherId: string): Promise<Result<Rating[]>> {
    return Result.ok(this.ratings.filter((r) => r.teacherId === teacherId));
  }

  async save(rating: Rating): Promise<Result<void>> {
    this.ratings.push(rating);
    return Result.ok();
  }

  async update(rating: Rating): Promise<Result<void>> {
    const index = this.ratings.findIndex((r) => r.id === rating.id);
    if (index >= 0) {
      this.ratings[index] = rating;
    }
    return Result.ok();
  }
}
