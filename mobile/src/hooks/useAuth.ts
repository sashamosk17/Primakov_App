import { useSelector } from "react-redux";
import { RootState } from "../redux/store";

export const useAuth = () => {
  const userId = useSelector((state: RootState) => state.auth.userId);
  const token = useSelector((state: RootState) => state.auth.token);
  return { userId, token };
};
