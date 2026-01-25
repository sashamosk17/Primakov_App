/**
 * Story Slice
 * Redux slice for managing story state
 */

import { createSlice, createAsyncThunk } from "@reduxjs/toolkit";
import { Story } from "../../types/api";
import { StoryService } from "../../api/StoryService";

export interface StoryState {
  stories: Story[];
  isLoading: boolean;
  error: string | null;
}

const initialState: StoryState = {
  stories: [],
  isLoading: false,
  error: null,
};

// Async thunks
export const fetchStories = createAsyncThunk("story/fetchStories", async (_, { rejectWithValue }) => {
  try {
    const stories = await StoryService.getStories();
    return stories;
  } catch (error: any) {
    return rejectWithValue(error.message || "Failed to fetch stories");
  }
});

export const markStoryAsViewed = createAsyncThunk(
  "story/markAsViewed",
  async (storyId: string, { rejectWithValue }) => {
    try {
      await StoryService.markAsViewed(storyId);
      return storyId;
    } catch (error: any) {
      return rejectWithValue(error.message || "Failed to mark story as viewed");
    }
  }
);

const storySlice = createSlice({
  name: "story",
  initialState,
  reducers: {
    clearError: (state) => {
      state.error = null;
    },
  },
  extraReducers: (builder) => {
    builder
      .addCase(fetchStories.pending, (state) => {
        state.isLoading = true;
        state.error = null;
      })
      .addCase(fetchStories.fulfilled, (state, action) => {
        state.isLoading = false;
        state.stories = action.payload;
      })
      .addCase(fetchStories.rejected, (state, action) => {
        state.isLoading = false;
        state.error = action.payload as string;
      })
      .addCase(markStoryAsViewed.fulfilled, (state, action) => {
        const story = state.stories.find((s) => s.id === action.payload);
        if (story) {
          story.isViewed = true;
        }
      });
  },
});

export const { clearError } = storySlice.actions;
export default storySlice.reducer;
