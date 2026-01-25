import { createSlice, PayloadAction } from "@reduxjs/toolkit";

interface AuthState {
  userId: string | null;
  token: string | null;
  userRole: "STUDENT" | "TEACHER" | "ADMIN" | null;
  isLoading: boolean;
}

const initialState: AuthState = {
  userId: null,
  token: null,
  userRole: null,
  isLoading: false
};

const authSlice = createSlice({
  name: "auth",
  initialState,
  reducers: {
    setUserId(state, action: PayloadAction<string | null>) {
      state.userId = action.payload;
    },
    setToken(state, action: PayloadAction<string | null>) {
      state.token = action.payload;
    },
    setUserRole(state, action: PayloadAction<"STUDENT" | "TEACHER" | "ADMIN" | null>) {
      state.userRole = action.payload;
    },
    setLoading(state, action: PayloadAction<boolean>) {
      state.isLoading = action.payload;
    }
  }
});

export const { setUserId, setToken, setUserRole, setLoading } = authSlice.actions;
export default authSlice.reducer;
