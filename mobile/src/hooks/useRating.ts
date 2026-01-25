import { useSelector } from "react-redux";
import { RootState } from "../redux/store";

export const useRating = () => {
  const ratings = useSelector((state: RootState) => state.rating.ratings);
  return { ratings };
};
