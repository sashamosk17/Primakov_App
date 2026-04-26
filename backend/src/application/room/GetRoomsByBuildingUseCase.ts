import { Result } from "../../shared/Result";
import { Room, PostgresRoomRepository } from "../../infrastructure/database/postgres/PostgresRoomRepository";

export class GetRoomsByBuildingUseCase {
  constructor(private roomRepository: PostgresRoomRepository) {}

  async execute(building: string): Promise<Result<Room[]>> {
    return await this.roomRepository.getByBuilding(building);
  }
}
