"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.RoomController = void 0;
const GetAllRoomsUseCase_1 = require("../../application/room/GetAllRoomsUseCase");
const GetRoomByNumberUseCase_1 = require("../../application/room/GetRoomByNumberUseCase");
const GetRoomsByBuildingUseCase_1 = require("../../application/room/GetRoomsByBuildingUseCase");
const GetRoomsByFloorUseCase_1 = require("../../application/room/GetRoomsByFloorUseCase");
class RoomController {
    constructor(repository) {
        this.repository = repository;
        this.getAll = async (req, res) => {
            const useCase = new GetAllRoomsUseCase_1.GetAllRoomsUseCase(this.repository);
            const result = await useCase.execute();
            if (result.isFailure) {
                return res.status(400).json({
                    status: "error",
                    error: { message: result.error },
                });
            }
            return res.json({
                status: "success",
                data: result.value,
            });
        };
        this.getByNumber = async (req, res) => {
            const { number } = req.params;
            const useCase = new GetRoomByNumberUseCase_1.GetRoomByNumberUseCase(this.repository);
            const result = await useCase.execute(number);
            if (result.isFailure) {
                return res.status(400).json({
                    status: "error",
                    error: { message: result.error },
                });
            }
            if (!result.value) {
                return res.status(404).json({
                    status: "error",
                    error: { message: "Room not found" },
                });
            }
            return res.json({
                status: "success",
                data: result.value,
            });
        };
        this.getByBuilding = async (req, res) => {
            const { building } = req.params;
            const useCase = new GetRoomsByBuildingUseCase_1.GetRoomsByBuildingUseCase(this.repository);
            const result = await useCase.execute(building);
            if (result.isFailure) {
                return res.status(400).json({
                    status: "error",
                    error: { message: result.error },
                });
            }
            return res.json({
                status: "success",
                data: result.value,
            });
        };
        this.getByFloor = async (req, res) => {
            const { building, floor } = req.params;
            const floorNumber = parseInt(floor, 10);
            if (isNaN(floorNumber)) {
                return res.status(400).json({
                    status: "error",
                    error: { message: "Invalid floor number" },
                });
            }
            const useCase = new GetRoomsByFloorUseCase_1.GetRoomsByFloorUseCase(this.repository);
            const result = await useCase.execute(building, floorNumber);
            if (result.isFailure) {
                return res.status(400).json({
                    status: "error",
                    error: { message: result.error },
                });
            }
            return res.json({
                status: "success",
                data: result.value,
            });
        };
    }
}
exports.RoomController = RoomController;
