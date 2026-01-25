import { createSlice, PayloadAction } from "@reduxjs/toolkit";

interface DeadlineState {
  items: unknown[];
  loading: boolean;
  error: string | null;
}

const initialState: DeadlineState = {
  items: [],
  loading: false,
  error: null
};

const deadlineSlice = createSlice({
  name: "deadlines",
  initialState,
  reducers: {
    setDeadlines(state, action: PayloadAction<unknown[]>) {
      state.items = action.payload;
    },
    addDeadline(state, action: PayloadAction<unknown>) {
      state.items.push(action.payload);
    },
    setLoading(state, action: PayloadAction<boolean>) {
      state.loading = action.payload;
    },
    setError(state, action: PayloadAction<string | null>) {
      state.error = action.payload;
    }
  }
});

export const { setDeadlines, addDeadline, setLoading, setError } = deadlineSlice.actions;
export default deadlineSlice.reducer;
