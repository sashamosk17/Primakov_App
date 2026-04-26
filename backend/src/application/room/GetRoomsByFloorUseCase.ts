import { Result } from "../../shared/Result";
import { Room, PostgresRoomRepository } from "../../infrastructure/database/postgres/PostgresRoomRepository";

export class GetRoomsByFloorUseCase {
  constructor(private roomRepository: PostgresRoomRepository) {}

  async execute(building: string, floor: number): Promise<Result<Room[]>> {
    return await this.roomRepository.getByFloor(building, floor);
  }
}
