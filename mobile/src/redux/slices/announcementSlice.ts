/**
 * Announcement Slice
 * Redux slice for managing announcement state
 */

import { createSlice, createAsyncThunk } from "@reduxjs/toolkit";
import { Announcement } from "../../types/api";
import { AnnouncementService } from "../../api/AnnouncementService";

export interface AnnouncementState {
  announcements: Announcement[];
  filteredAnnouncements: Announcement[];
  isLoading: boolean;
  error: string | null;
}

const initialState: AnnouncementState = {
  announcements: [],
  filteredAnnouncements: [],
  isLoading: false,
  error: null,
};

// Async thunks
export const fetchAnnouncements = createAsyncThunk(
  "announcement/fetchAnnouncements",
  async (_, { rejectWithValue }) => {
    try {
      const announcements = await AnnouncementService.getAnnouncements();
      return announcements;
    } catch (error: any) {
      return rejectWithValue(error.message || "Failed to fetch announcements");
    }
  }
);

export const fetchAnnouncementsByCategory = createAsyncThunk(
  "announcement/fetchByCategory",
  async (category: string, { rejectWithValue }) => {
    try {
      const announcements = await AnnouncementService.getByCategory(category);
      return announcements;
    } catch (error: any) {
      return rejectWithValue(error.message || "Failed to fetch announcements");
    }
  }
);

const announcementSlice = createSlice({
  name: "announcement",
  initialState,
  reducers: {
    clearError: (state) => {
      state.error = null;
    },
    filterByCategory: (state, action) => {
      const category = action.payload;
      if (category) {
        state.filteredAnnouncements = state.announcements.filter(
          (a) => a.category === category
        );
      } else {
        state.filteredAnnouncements = state.announcements;
      }
    },
  },
  extraReducers: (builder) => {
    builder
      .addCase(fetchAnnouncements.pending, (state) => {
        state.isLoading = true;
        state.error = null;
      })
      .addCase(fetchAnnouncements.fulfilled, (state, action) => {
        state.isLoading = false;
        state.announcements = action.payload;
        state.filteredAnnouncements = action.payload;
      })
      .addCase(fetchAnnouncements.rejected, (state, action) => {
        state.isLoading = false;
        state.error = action.payload as string;
      })
      .addCase(fetchAnnouncementsByCategory.pending, (state) => {
        state.isLoading = true;
      })
      .addCase(fetchAnnouncementsByCategory.fulfilled, (state, action) => {
        state.isLoading = false;
        state.filteredAnnouncements = action.payload;
      })
      .addCase(fetchAnnouncementsByCategory.rejected, (state, action) => {
        state.isLoading = false;
        state.error = action.payload as string;
      });
  },
});

export const { clearError, filterByCategory } = announcementSlice.actions;
export default announcementSlice.reducer;
