/**
 * API Response Types
 */

export interface User {
  id: string;
  email: string;
  firstName: string;
  lastName: string;
  role: "STUDENT" | "TEACHER" | "ADMIN";
  isActive: boolean;
  vkId?: string;
}

export interface Lesson {
  id: string;
  subject: string;
  teacherId: string;
  startTime: string;
  endTime: string;
  room: string;
  floor: number;
  hasHomework: boolean;
}

export interface Schedule {
  id: string;
  groupId: string;
  date: string;
  lessons: Lesson[];
}

export interface Deadline {
  id: string;
  title: string;
  description: string;
  dueDate: string;
  userId: string;
  status: "PENDING" | "COMPLETED" | "OVERDUE";
  subject?: string;
  createdAt: string;
  completedAt?: string;
}

export interface Story {
  id: string;
  title: string;
  description: string;
  imageUrl?: string;
  videoUrl?: string;
  createdAt: string;
  expiresAt: string;
  viewedBy: string[];
  author: string;
  isViewed?: boolean;
}

export interface Announcement {
  id: string;
  title: string;
  description: string;
  content?: string;
  imageUrl?: string;
  date: string;
  category: "EVENT" | "NEWS" | "MAINTENANCE" | "IMPORTANT";
  createdAt: string;
  authorId: string;
}

export interface Rating {
  id: string;
  teacherId: string;
  userId: string;
  value: number;
  createdAt: string;
}

export interface AuthResponse {
  user: User;
  token: string;
  refreshToken?: string;
}

export interface ApiResponse<T> {
  status: "success" | "error";
  data?: T;
  error?: {
    message: string;
  };
}
