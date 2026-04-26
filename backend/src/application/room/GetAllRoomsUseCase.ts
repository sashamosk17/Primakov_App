import { Result } from "../../shared/Result";
import { Room, PostgresRoomRepository } from "../../infrastructure/database/postgres/PostgresRoomRepository";

export class GetAllRoomsUseCase {
  constructor(private roomRepository: PostgresRoomRepository) {}

  async execute(): Promise<Result<Room[]>> {
    return await this.roomRepository.getAll();
  }
}
