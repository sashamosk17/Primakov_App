import { useSelector } from "react-redux";
import { RootState } from "../redux/store";

export const useDeadlines = () => {
  const items = useSelector((state: RootState) => state.deadlines.items);
  const loading = useSelector((state: RootState) => state.deadlines.loading);
  return { items, loading };
};
