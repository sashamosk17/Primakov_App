import { configureStore } from "@reduxjs/toolkit";
import authReducer from "./slices/authSlice";
import scheduleReducer from "./slices/scheduleSlice";
import deadlineReducer from "./slices/deadlineSlice";
import ratingReducer from "./slices/ratingSlice";
import storyReducer from "./slices/storySlice";
import announcementReducer from "./slices/announcementSlice";
import uiReducer from "./slices/uiSlice";

export const store = configureStore({
  reducer: {
    auth: authReducer,
    schedule: scheduleReducer,
    deadlines: deadlineReducer,
    rating: ratingReducer,
    story: storyReducer,
    announcement: announcementReducer,
    ui: uiReducer
  }
});

export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;
