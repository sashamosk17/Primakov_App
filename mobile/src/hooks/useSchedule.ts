import { useSelector } from "react-redux";
import { RootState } from "../redux/store";

export const useSchedule = () => {
  const schedule = useSelector((state: RootState) => state.schedule.schedule);
  const loading = useSelector((state: RootState) => state.schedule.loading);
  return { schedule, loading };
};
