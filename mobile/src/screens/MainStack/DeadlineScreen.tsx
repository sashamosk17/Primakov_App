/**
 * DeadlineScreen
 * Screen showing active and completed deadlines
 */

import React, { useEffect, useState } from "react";
import {
  View,
  Text,
  StyleSheet,
  FlatList,
  TouchableOpacity,
  ScrollView,
  Modal,
  Button,
} from "react-native";
import { useDispatch, useSelector } from "react-redux";
import { AppDispatch, RootState } from "../../redux/store";
import { DeadlineService } from "../../api/DeadlineService";
import { Deadline } from "../../types/api";

/**
 * DeadlineCard Component
 */
const DeadlineCard: React.FC<{ deadline: Deadline; onComplete: () => void }> = ({
  deadline,
  onComplete,
}) => {
  const daysLeft = Math.ceil(
    (new Date(deadline.dueDate).getTime() - Date.now()) / (1000 * 60 * 60 * 24)
  );

  const getStatusColor = () => {
    if (deadline.status === "COMPLETED") return "#4caf50";
    if (daysLeft > 5) return "#4caf50";
    if (daysLeft > 2) return "#ff9800";
    return "#f44336";
  };

  return (
    <View style={[styles.card, { borderLeftColor: getStatusColor(), borderLeftWidth: 4 }]}>
      <View style={styles.cardHeader}>
        <Text style={styles.cardTitle}>{deadline.title}</Text>
        <View style={styles.statusBadge}>
          <Text style={styles.statusText}>
            {deadline.status === "COMPLETED" ? "✓" : `${daysLeft}д`}
          </Text>
        </View>
      </View>
      <Text style={styles.cardDescription}>{deadline.description}</Text>
      {deadline.subject && (
        <Text style={styles.cardSubject}>📚 {deadline.subject}</Text>
      )}
      <View style={styles.cardFooter}>
        <Text style={styles.dueDate}>
          📅 До: {new Date(deadline.dueDate).toLocaleDateString("ru-RU")}
        </Text>
        {deadline.status !== "COMPLETED" && (
          <TouchableOpacity style={styles.completeBtn} onPress={onComplete}>
            <Text style={styles.completeBtnText}>Выполнено</Text>
          </TouchableOpacity>
        )}
      </View>
    </View>
  );
};

export const DeadlineScreen: React.FC<{ navigation: any }> = ({ navigation }) => {
  const userId = useSelector((state: RootState) => state.auth.userId);
  const [deadlines, setDeadlines] = useState<Deadline[]>([]);
  const [filteredDeadlines, setFilteredDeadlines] = useState<Deadline[]>([]);
  const [selectedTab, setSelectedTab] = useState<"active" | "completed">("active");
  const [isLoading, setIsLoading] = useState(false);
  const [showCreateModal, setShowCreateModal] = useState(false);

  useEffect(() => {
    loadDeadlines();
  }, [userId]);

  useEffect(() => {
    filterDeadlines();
  }, [deadlines, selectedTab]);

  const loadDeadlines = async () => {
    if (!userId) return;
    setIsLoading(true);
    try {
      const active = await DeadlineService.getDeadlines(userId, "PENDING");
      const completed = await DeadlineService.getDeadlines(userId, "COMPLETED");
      setDeadlines([...active, ...completed]);
    } catch (error) {
      console.error("Failed to load deadlines", error);
    } finally {
      setIsLoading(false);
    }
  };

  const filterDeadlines = () => {
    const filtered = deadlines.filter((d) => {
      if (selectedTab === "active") {
        return d.status !== "COMPLETED";
      }
      return d.status === "COMPLETED";
    });
    setFilteredDeadlines(filtered);
  };

  const handleComplete = async (deadlineId: string) => {
    try {
      await DeadlineService.completeDeadline(deadlineId);
      loadDeadlines();
    } catch (error) {
      console.error("Failed to complete deadline", error);
    }
  };

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.headerTitle}>Дедлайны</Text>
        <TouchableOpacity
          style={styles.fabButton}
          onPress={() => setShowCreateModal(true)}
        >
          <Text style={styles.fabText}>+</Text>
        </TouchableOpacity>
      </View>

      {/* Tabs */}
      <View style={styles.tabsContainer}>
        <TouchableOpacity
          style={[styles.tab, selectedTab === "active" && styles.tabActive]}
          onPress={() => setSelectedTab("active")}
        >
          <Text
            style={[
              styles.tabText,
              selectedTab === "active" && styles.tabTextActive,
            ]}
          >
            Активные
          </Text>
        </TouchableOpacity>
        <TouchableOpacity
          style={[styles.tab, selectedTab === "completed" && styles.tabActive]}
          onPress={() => setSelectedTab("completed")}
        >
          <Text
            style={[
              styles.tabText,
              selectedTab === "completed" && styles.tabTextActive,
            ]}
          >
            Выполненные
          </Text>
        </TouchableOpacity>
      </View>

      {/* Deadlines List */}
      {isLoading ? (
        <Text style={styles.loadingText}>Загрузка...</Text>
      ) : filteredDeadlines.length > 0 ? (
        <FlatList
          data={filteredDeadlines}
          renderItem={({ item }) => (
            <DeadlineCard
              deadline={item}
              onComplete={() => handleComplete(item.id)}
            />
          )}
          keyExtractor={(item) => item.id}
          contentContainerStyle={styles.listContent}
        />
      ) : (
        <View style={styles.emptyContainer}>
          <Text style={styles.emptyText}>
            {selectedTab === "active"
              ? "Все дедлайны выполнены!"
              : "Нет выполненных дедлайнов"}
          </Text>
        </View>
      )}

      {/* Create Modal */}
      <Modal visible={showCreateModal} transparent onRequestClose={() => setShowCreateModal(false)}>
        <View style={styles.modalOverlay}>
          <View style={styles.modal}>
            <Text style={styles.modalTitle}>Новый дедлайн</Text>
            <Button title="Закрыть" onPress={() => setShowCreateModal(false)} />
          </View>
        </View>
      </Modal>
    </View>
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
  fabButton: {
    width: 50,
    height: 50,
    borderRadius: 25,
    backgroundColor: "#1976d2",
    justifyContent: "center",
    alignItems: "center",
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.3,
    shadowRadius: 3,
    elevation: 5,
  },
  fabText: {
    fontSize: 28,
    color: "white",
    fontWeight: "bold",
  },
  tabsContainer: {
    flexDirection: "row",
    backgroundColor: "white",
    borderBottomWidth: 1,
    borderBottomColor: "#eee",
  },
  tab: {
    flex: 1,
    paddingVertical: 12,
    alignItems: "center",
    borderBottomWidth: 2,
    borderBottomColor: "transparent",
  },
  tabActive: {
    borderBottomColor: "#1976d2",
  },
  tabText: {
    fontSize: 14,
    color: "#999",
    fontWeight: "500",
  },
  tabTextActive: {
    color: "#1976d2",
    fontWeight: "bold",
  },
  listContent: {
    padding: 12,
  },
  card: {
    backgroundColor: "white",
    borderRadius: 8,
    padding: 16,
    marginBottom: 12,
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.1,
    shadowRadius: 2,
    elevation: 2,
  },
  cardHeader: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
    marginBottom: 8,
  },
  cardTitle: {
    fontSize: 16,
    fontWeight: "bold",
    color: "#333",
    flex: 1,
  },
  statusBadge: {
    backgroundColor: "#f0f0f0",
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 4,
  },
  statusText: {
    fontSize: 12,
    fontWeight: "bold",
    color: "#333",
  },
  cardDescription: {
    fontSize: 13,
    color: "#666",
    marginBottom: 8,
    lineHeight: 18,
  },
  cardSubject: {
    fontSize: 12,
    color: "#999",
    marginBottom: 12,
  },
  cardFooter: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
  },
  dueDate: {
    fontSize: 12,
    color: "#666",
  },
  completeBtn: {
    backgroundColor: "#4caf50",
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 4,
  },
  completeBtnText: {
    color: "white",
    fontSize: 12,
    fontWeight: "600",
  },
  loadingText: {
    textAlign: "center",
    color: "#999",
    fontSize: 14,
    marginTop: 20,
  },
  emptyContainer: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center",
  },
  emptyText: {
    color: "#999",
    fontSize: 16,
  },
  modalOverlay: {
    flex: 1,
    backgroundColor: "rgba(0,0,0,0.5)",
    justifyContent: "flex-end",
  },
  modal: {
    backgroundColor: "white",
    padding: 20,
    borderTopLeftRadius: 12,
    borderTopRightRadius: 12,
  },
  modalTitle: {
    fontSize: 18,
    fontWeight: "bold",
    marginBottom: 16,
    color: "#333",
  },
});
