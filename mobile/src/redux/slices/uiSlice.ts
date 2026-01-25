import { createSlice, PayloadAction } from "@reduxjs/toolkit";

interface UiState {
  theme: "light" | "dark";
  language: "ru" | "en";
}

const initialState: UiState = {
  theme: "light",
  language: "ru"
};

const uiSlice = createSlice({
  name: "ui",
  initialState,
  reducers: {
    setTheme(state, action: PayloadAction<"light" | "dark">) {
      state.theme = action.payload;
    },
    setLanguage(state, action: PayloadAction<"ru" | "en">) {
      state.language = action.payload;
    }
  }
});

export const { setTheme, setLanguage } = uiSlice.actions;
export default uiSlice.reducer;
