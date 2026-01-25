import { createSlice, PayloadAction } from "@reduxjs/toolkit";

interface RatingState {
  ratings: unknown[];
}

const initialState: RatingState = {
  ratings: []
};

const ratingSlice = createSlice({
  name: "rating",
  initialState,
  reducers: {
    setRatings(state, action: PayloadAction<unknown[]>) {
      state.ratings = action.payload;
    }
  }
});

export const { setRatings } = ratingSlice.actions;
export default ratingSlice.reducer;
