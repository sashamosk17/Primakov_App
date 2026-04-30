import { Rating } from "../../../domain/entities/Rating";
import { IRatingRepository } from "../../../domain/repositories/IRatingRepository";
import { Result } from "../../../shared/Result";

export class MockRatingRepository implements IRatingRepository {
  private ratings: Rating[] = [];

  constructor() {
    this.initializeTestData();
  }

  private initializeTestData(): void {
    const teacher1Ratings = [
      { userId: "user-1", value: 5, comment: "Отличный преподаватель!" },
      { userId: "user-2", value: 4, comment: "Хорошо объясняет материал" },
      { userId: "user-3", value: 5, comment: "Очень интересные уроки" },
      { userId: "user-1", value: 4, comment: "Понятно и доступно" },
    ];

    teacher1Ratings.forEach((rating, index) => {
      this.ratings.push(
        new Rating(
          `rating-teacher1-${index + 1}`,
          "teacher-1",
          rating.userId,
          rating.value,
          new Date(Date.now() - (10 - index) * 24 * 60 * 60 * 1000),
          rating.comment
        )
      );
    });

    const teacher2Ratings = [
      { userId: "user-1", value: 3, comment: "Нормально" },
      { userId: "user-2", value: 4, comment: "Хороший учитель" },
      { userId: "user-3", value: 4, comment: "Интересно" },
      { userId: "user-2", value: 5, comment: "Отлично!" },
    ];

    teacher2Ratings.forEach((rating, index) => {
      this.ratings.push(
        new Rating(
          `rating-teacher2-${index + 1}`,
          "teacher-2",
          rating.userId,
          rating.value,
          new Date(Date.now() - (12 - index) * 24 * 60 * 60 * 1000),
          rating.comment
        )
      );
    });
  }

  async getByTeacher(teacherId: string): Promise<Result<Rating[]>> {
    const teacherRatings = this.ratings.filter((r) => r.teacherId === teacherId);
    return Result.ok(teacherRatings);
  }

  async save(rating: Rating): Promise<Result<void>> {
    this.ratings.push(rating);
    return Result.ok();
  }

  async update(rating: Rating): Promise<Result<void>> {
    const existingIndex = this.ratings.findIndex((r) => r.id === rating.id);
    if (existingIndex >= 0) {
      this.ratings[existingIndex] = rating;
    }
    return Result.ok();
  }
}
