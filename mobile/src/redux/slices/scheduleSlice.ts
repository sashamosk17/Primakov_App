import { createSlice, PayloadAction } from "@reduxjs/toolkit";

interface ScheduleState {
  schedule: unknown;
  loading: boolean;
  error: string | null;
}

const initialState: ScheduleState = {
  schedule: null,
  loading: false,
  error: null
};

const scheduleSlice = createSlice({
  name: "schedule",
  initialState,
  reducers: {
    setSchedule(state, action: PayloadAction<unknown>) {
      state.schedule = action.payload;
    },
    setLoading(state, action: PayloadAction<boolean>) {
      state.loading = action.payload;
    },
    setError(state, action: PayloadAction<string | null>) {
      state.error = action.payload;
    }
  }
});

export const { setSchedule, setLoading, setError } = scheduleSlice.actions;
export default scheduleSlice.reducer;
