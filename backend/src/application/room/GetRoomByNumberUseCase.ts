import { Result } from "../../shared/Result";
import { Room, PostgresRoomRepository } from "../../infrastructure/database/postgres/PostgresRoomRepository";

export class GetRoomByNumberUseCase {
  constructor(private roomRepository: PostgresRoomRepository) {}

  async execute(number: string): Promise<Result<Room | null>> {
    return await this.roomRepository.getByNumber(number);
  }
}
