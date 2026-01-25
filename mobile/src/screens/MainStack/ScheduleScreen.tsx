/**
 * ScheduleScreen
 * Main screen showing Stories, Schedule, and Calendar
 */

import React, { useEffect, useState } from "react";
import {
  View,
  Text,
  StyleSheet,
  FlatList,
  ScrollView,
  TouchableOpacity,
  Modal,
  Image,
} from "react-native";
import { useDispatch, useSelector } from "react-redux";
import { AppDispatch, RootState } from "../../redux/store";
import { fetchStories } from "../../redux/slices/storySlice";
import { ScheduleService } from "../../api/ScheduleService";
import { Schedule, Lesson, Story } from "../../types/api";

/**
 * StoriesBar Component
 */
const StoriesBar: React.FC<{ stories: Story[] }> = ({ stories }) => {
  const [selectedStory, setSelectedStory] = useState<Story | null>(null);

  return (
    <>
      <FlatList
        data={stories}
        horizontal
        showsHorizontalScrollIndicator={false}
        contentContainerStyle={styles.storiesContainer}
        renderItem={({ item }) => (
          <TouchableOpacity onPress={() => setSelectedStory(item)} style={styles.storyAvatar}>
            <View
              style={[
                styles.storyCircle,
                { borderColor: item.viewedBy.length > 0 ? "#999" : "#1976d2" },
              ]}
            >
              <Text style={styles.storyPlaceholder}>📖</Text>
            </View>
            <Text style={styles.storyTitle} numberOfLines={1}>
              {item.title.substring(0, 10)}
            </Text>
          </TouchableOpacity>
        )}
        keyExtractor={(item) => item.id}
      />

      {selectedStory && (
        <Modal
          visible={!!selectedStory}
          transparent
          onRequestClose={() => setSelectedStory(null)}
        >
          <View style={styles.modalContent}>
            <View style={styles.storyInfo}>
              <Text style={styles.storyModalTitle}>{selectedStory.title}</Text>
              <Text style={styles.storyDescription}>{selectedStory.description}</Text>
            </View>
            <TouchableOpacity
              onPress={() => setSelectedStory(null)}
              style={styles.closeButton}
            >
              <Text style={styles.closeButtonText}>✕</Text>
            </TouchableOpacity>
          </View>
        </Modal>
      )}
    </>
  );
};

/**
 * LessonCard Component
 */
const LessonCard: React.FC<{ lesson: Lesson }> = ({ lesson }) => {
  return (
    <View style={styles.lessonCard}>
      <View style={styles.lessonTime}>
        <Text style={styles.lessonTimeText}>
          {lesson.startTime}-{lesson.endTime}
        </Text>
      </View>
      <View style={styles.lessonDetails}>
        <Text style={styles.lessonSubject}>{lesson.subject}</Text>
        <Text style={styles.lessonTeacher}>👨‍🏫 Учитель</Text>
        <View style={styles.lessonMeta}>
          <Text style={styles.metaText}>🚪 Каб. {lesson.room}, этаж {lesson.floor}</Text>
        </View>
        {lesson.hasHomework && (
          <Text style={styles.homeworkLabel}>📝 Домашнее задание</Text>
        )}
      </View>
    </View>
  );
};

export const ScheduleScreen = () => {
  const dispatch = useDispatch<AppDispatch>();
  const { stories, isLoading } = useSelector((state: RootState) => state.story);
  const [schedule, setSchedule] = useState<Schedule | null>(null);
  const [selectedDate] = useState(new Date());

  const daysOfWeek = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб"];

  useEffect(() => {
    dispatch(fetchStories());
    loadSchedule(selectedDate);
  }, [dispatch]);

  const loadSchedule = async (date: Date) => {
    try {
      const scheduleData = await ScheduleService.getScheduleByDate("10A-Math", 
        date.toISOString().split("T")[0]
      );
      setSchedule(scheduleData);
    } catch (error) {
      console.error("Failed to load schedule", error);
    }
  };

  return (
    <ScrollView style={styles.container}>
      {/* Header */}
      <View style={styles.header}>
        <Text style={styles.headerTitle}>Расписание</Text>
        <TouchableOpacity style={styles.calendarButton}>
          <Text>📅</Text>
        </TouchableOpacity>
      </View>

      {/* Stories */}
      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Объявления</Text>
        {isLoading ? (
          <Text>Загрузка...</Text>
        ) : (
          <StoriesBar stories={stories} />
        )}
      </View>

      {/* Day Tabs */}
      <ScrollView horizontal style={styles.daysContainer} showsHorizontalScrollIndicator={false}>
        {daysOfWeek.map((day) => (
          <TouchableOpacity key={day} style={[styles.dayTab, day === "Пн" && styles.dayTabActive]}>
            <Text style={[styles.dayTabText, day === "Пн" && styles.dayTabTextActive]}>
              {day}
            </Text>
          </TouchableOpacity>
        ))}
      </ScrollView>

      {/* Lessons */}
      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Уроки на сегодня</Text>
        {schedule?.lessons && schedule.lessons.length > 0 ? (
          schedule.lessons.map((lesson) => (
            <LessonCard key={lesson.id} lesson={lesson} />
          ))
        ) : (
          <Text style={styles.emptyText}>Нет уроков</Text>
        )}
      </View>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#f5f5f5",
  },
  header: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
    paddingHorizontal: 16,
    paddingVertical: 12,
    backgroundColor: "white",
    borderBottomWidth: 1,
    borderBottomColor: "#eee",
  },
  headerTitle: {
    fontSize: 24,
    fontWeight: "bold",
    color: "#333",
  },
  calendarButton: {
    padding: 8,
  },
  section: {
    padding: 16,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: "600",
    marginBottom: 12,
    color: "#333",
  },
  storiesContainer: {
    paddingVertical: 8,
  },
  storyAvatar: {
    marginRight: 12,
    alignItems: "center",
  },
  storyCircle: {
    width: 80,
    height: 80,
    borderRadius: 40,
    borderWidth: 3,
    backgroundColor: "#f0f0f0",
    justifyContent: "center",
    alignItems: "center",
  },
  storyPlaceholder: {
    fontSize: 32,
  },
  storyTitle: {
    marginTop: 8,
    fontSize: 12,
    width: 80,
    textAlign: "center",
    color: "#666",
  },
  modalContent: {
    flex: 1,
    backgroundColor: "rgba(0,0,0,0.8)",
    justifyContent: "center",
    alignItems: "center",
  },
  storyInfo: {
    backgroundColor: "white",
    padding: 16,
    borderRadius: 8,
    width: "80%",
  },
  storyModalTitle: {
    fontSize: 18,
    fontWeight: "bold",
    marginBottom: 8,
    color: "#333",
  },
  storyDescription: {
    fontSize: 14,
    color: "#666",
  },
  closeButton: {
    position: "absolute",
    top: 40,
    right: 20,
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: "rgba(255,255,255,0.3)",
    justifyContent: "center",
    alignItems: "center",
  },
  closeButtonText: {
    fontSize: 24,
    color: "white",
  },
  daysContainer: {
    paddingHorizontal: 8,
    backgroundColor: "white",
  },
  dayTab: {
    paddingVertical: 12,
    paddingHorizontal: 16,
    borderBottomWidth: 2,
    borderBottomColor: "transparent",
  },
  dayTabActive: {
    borderBottomColor: "#1976d2",
  },
  dayTabText: {
    fontSize: 14,
    color: "#999",
    fontWeight: "500",
  },
  dayTabTextActive: {
    color: "#1976d2",
    fontWeight: "bold",
  },
  lessonCard: {
    backgroundColor: "white",
    borderRadius: 8,
    marginBottom: 12,
    overflow: "hidden",
    flexDirection: "row",
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.1,
    shadowRadius: 2,
    elevation: 2,
  },
  lessonTime: {
    backgroundColor: "#1976d2",
    paddingVertical: 16,
    paddingHorizontal: 12,
    justifyContent: "center",
    minWidth: 50,
  },
  lessonTimeText: {
    color: "white",
    fontSize: 11,
    fontWeight: "bold",
    textAlign: "center",
  },
  lessonDetails: {
    flex: 1,
    padding: 12,
  },
  lessonSubject: {
    fontSize: 16,
    fontWeight: "bold",
    color: "#333",
    marginBottom: 4,
  },
  lessonTeacher: {
    fontSize: 13,
    color: "#666",
    marginBottom: 8,
  },
  lessonMeta: {
    marginBottom: 8,
  },
  metaText: {
    fontSize: 12,
    color: "#999",
  },
  homeworkLabel: {
    fontSize: 12,
    color: "#ff9800",
    fontWeight: "500",
  },
  emptyText: {
    textAlign: "center",
    color: "#999",
    fontSize: 14,
    paddingVertical: 20,
  },
});
