/**
 * ProfileScreen
 * User profile and settings screen
 * 
 * Responsibilities:
 * - Display user profile information
 * - Settings management (notifications, theme, language)
 * - User logout functionality
 * - User permissions check
 */

import React, { useEffect } from "react";
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  Switch,
  Alert,
  ActivityIndicator,
} from "react-native";
import AsyncStorage from "@react-native-async-storage/async-storage";
import { useDispatch, useSelector } from "react-redux";
import { RootState, AppDispatch } from "../../redux/store";
import { setUserId, setToken } from "../../redux/slices/authSlice";

/**
 * SettingItem Props Interface
 */
interface SettingItemProps {
  title: string;
  value?: string | boolean;
  onToggle?: (value: boolean) => void;
  onPress?: () => void;
  isToggle?: boolean;
}

/**
 * SettingItem Component
 * Renders individual setting item with toggle or button
 */
const SettingItem: React.FC<SettingItemProps> = (props: SettingItemProps) => {
  const { title, value, onToggle, onPress, isToggle } = props;
  return (
    <TouchableOpacity
      style={styles.settingItem}
      onPress={onPress}
      disabled={isToggle}
    >
      <Text style={styles.settingTitle}>{title}</Text>
      {isToggle ? (
        <Switch
          value={typeof value === "boolean" ? value : false}
          onValueChange={onToggle}
        />
      ) : (
        <Text style={styles.settingValue}>{value || ">"}</Text>
      )}
    </TouchableOpacity>
  );
};

/**
 * ProfileScreen Props Interface
 */
interface ProfileScreenProps {
  navigation: any; // React Navigation's BottomTabNavigationProp
}

export const ProfileScreen: React.FC<ProfileScreenProps> = (props: ProfileScreenProps) => {
  const { navigation } = props;
  const dispatch = useDispatch<AppDispatch>();
  const userId = useSelector((state: RootState) => state.auth.userId);
  const userRole = useSelector((state: RootState) => state.auth.userRole || "student");
  const [notificationsEnabled, setNotificationsEnabled] = React.useState(true);
  const [darkMode, setDarkMode] = React.useState(false);
  const [isLoading, setIsLoading] = React.useState(false);

  useEffect(() => {
    // Load user settings from AsyncStorage
    loadUserSettings();
  }, []);

  const loadUserSettings = async () => {
    try {
      const savedNotifications = await AsyncStorage.getItem("notificationsEnabled");
      const savedDarkMode = await AsyncStorage.getItem("darkMode");
      
      if (savedNotifications !== null) {
        setNotificationsEnabled(JSON.parse(savedNotifications));
      }
      if (savedDarkMode !== null) {
        setDarkMode(JSON.parse(savedDarkMode));
      }
    } catch (error) {
      console.error("Failed to load user settings:", error);
    }
  };

  const handleNotificationChange = async (value: boolean) => {
    try {
      setNotificationsEnabled(value);
      await AsyncStorage.setItem("notificationsEnabled", JSON.stringify(value));
    } catch (error) {
      console.error("Failed to save notification setting:", error);
      Alert.alert("Ошибка", "Не удалось сохранить настройки");
    }
  };

  const handleDarkModeChange = async (value: boolean) => {
    try {
      setDarkMode(value);
      await AsyncStorage.setItem("darkMode", JSON.stringify(value));
    } catch (error) {
      console.error("Failed to save theme setting:", error);
      Alert.alert("Ошибка", "Не удалось сохранить настройки");
    }
  };

  const handleLogout = async () => {
    Alert.alert(
      "Выход",
      "Вы уверены, что хотите выйти из аккаунта?",
      [
        {
          text: "Отмена",
          onPress: () => {},
          style: "cancel",
        },
        {
          text: "Выход",
          onPress: async () => {
            try {
              setIsLoading(true);
              // Clear Redux state
              dispatch(setUserId(null));
              dispatch(setToken(null));
              
              // Clear AsyncStorage
              await AsyncStorage.removeItem("token");
              await AsyncStorage.removeItem("userId");
              await AsyncStorage.removeItem("userRole");
              
              // Navigate to Auth screen
              if (navigation?.getParent?.()?.reset) {
                navigation.getParent().reset({
                  index: 0,
                  routes: [{ name: "Auth" }],
                });
              } else if (navigation?.reset) {
                navigation.reset({
                  index: 0,
                  routes: [{ name: "Auth" }],
                });
              }
            } catch (error) {
              console.error("Logout error:", error);
              Alert.alert("Ошибка", "Не удалось выполнить выход");
            } finally {
              setIsLoading(false);
            }
          },
          style: "destructive",
        },
      ]
    );
  };

  const handleLibraryPress = () => {
    if (userRole !== "ADMIN") {
      Alert.alert("Ограничение", "Эта функция доступна только администраторам");
      return;
    }
    // Navigate to library screen
  };

  const handleExportPress = () => {
    Alert.alert("Экспорт", "Экспорт дедлайнов в разработке");
  };

  const handleClearCachePress = async () => {
    Alert.alert(
      "Очистить кэш",
      "Это удалит кэшированные данные. Продолжить?",
      [
        { text: "Отмена", style: "cancel" },
        {
          text: "Очистить",
          style: "destructive",
          onPress: async () => {
            try {
              await AsyncStorage.removeItem("cachedSchedule");
              await AsyncStorage.removeItem("cachedDeadlines");
              Alert.alert("Успешно", "Кэш очищен");
            } catch (error) {
              console.error("Failed to clear cache:", error);
              Alert.alert("Ошибка", "Не удалось очистить кэш");
            }
          },
        },
      ]
    );
  };

  const handleReportPress = () => {
    Alert.alert(
      "Сообщить о проблеме",
      "Спасибо что помогаете улучшать приложение!",
      [{ text: "OK", onPress: () => {} }]
    );
  };

  // Check if user is authenticated
  if (!userId) {
    return (
      <View style={styles.container}>
        <View style={[styles.header, { justifyContent: "center" }]}>
          <Text style={styles.userName}>Требуется вход в аккаунт</Text>
        </View>
      </View>
    );
  }

  return (
    <ScrollView style={styles.container}>
      {isLoading && (
        <View style={styles.loadingOverlay}>
          <ActivityIndicator size="large" color="#1976d2" />
        </View>
      )}

      {/* Profile Header */}
      <View style={styles.header}>
        <View style={styles.avatar}>
          <Text style={styles.avatarText}>👤</Text>
        </View>
        <View style={styles.userInfo}>
          <Text style={styles.userName}>Иван Петров</Text>
          <Text style={styles.userClass}>10A • {userRole === "ADMIN" ? "Администратор" : "Студент"}</Text>
          <Text style={styles.userId}>ID: {userId}</Text>
        </View>
      </View>

      {/* Settings */}
      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Настройки</Text>

        <SettingItem
          title="⚙️ Уведомления"
          value={notificationsEnabled}
          onToggle={handleNotificationChange}
          isToggle
        />

        <SettingItem
          title="🌓 Темная тема"
          value={darkMode}
          onToggle={handleDarkModeChange}
          isToggle
        />

        <SettingItem
          title="🌐 Язык"
          value="Русский"
          onPress={() => Alert.alert("Язык", "Выбор языка в разработке")}
        />

        {userRole === "ADMIN" && (
          <SettingItem
            title="📚 Школьная библиотека"
            value="→"
            onPress={handleLibraryPress}
          />
        )}

        <SettingItem
          title="📥 Экспорт дедлайнов"
          value="→"
          onPress={handleExportPress}
        />

        <SettingItem
          title="🐛 Сообщить о проблеме"
          value="→"
          onPress={handleReportPress}
        />

        <SettingItem
          title="🗑️ Очистить кэш"
          value="→"
          onPress={handleClearCachePress}
        />
      </View>

      {/* Logout */}
      <TouchableOpacity style={styles.logoutButton} onPress={handleLogout}>
        <Text style={styles.logoutButtonText}>Выход</Text>
      </TouchableOpacity>

      <View style={styles.footer}>
        <Text style={styles.versionText}>PrimakovApp v0.1.0</Text>
        <Text style={styles.versionText}>© 2024 Школа им. Примакова</Text>
      </View>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#f5f5f5",
  },
  loadingOverlay: {
    position: "absolute",
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: "rgba(0, 0, 0, 0.3)",
    justifyContent: "center",
    alignItems: "center",
    zIndex: 999,
  },
  header: {
    flexDirection: "row",
    alignItems: "center",
    backgroundColor: "white",
    padding: 16,
    borderBottomWidth: 1,
    borderBottomColor: "#eee",
  },
  avatar: {
    width: 60,
    height: 60,
    borderRadius: 30,
    backgroundColor: "#1976d2",
    justifyContent: "center",
    alignItems: "center",
    marginRight: 16,
  },
  avatarText: {
    fontSize: 32,
  },
  userInfo: {
    flex: 1,
  },
  userName: {
    fontSize: 18,
    fontWeight: "bold",
    color: "#333",
  },
  userClass: {
    fontSize: 13,
    color: "#999",
    marginTop: 4,
  },
  userId: {
    fontSize: 12,
    color: "#bbb",
    marginTop: 2,
  },
  section: {
    backgroundColor: "white",
    marginTop: 12,
    paddingHorizontal: 0,
  },
  sectionTitle: {
    fontSize: 14,
    fontWeight: "600",
    color: "#999",
    paddingHorizontal: 16,
    paddingVertical: 12,
    textTransform: "uppercase",
  },
  settingItem: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
    paddingHorizontal: 16,
    paddingVertical: 16,
    borderBottomWidth: 1,
    borderBottomColor: "#f0f0f0",
  },
  settingTitle: {
    fontSize: 15,
    color: "#333",
    flex: 1,
  },
  settingValue: {
    fontSize: 15,
    color: "#999",
  },
  logoutButton: {
    backgroundColor: "#f44336",
    marginHorizontal: 16,
    marginTop: 24,
    paddingVertical: 12,
    borderRadius: 8,
    alignItems: "center",
  },
  logoutButtonText: {
    color: "white",
    fontSize: 16,
    fontWeight: "600",
  },
  footer: {
    alignItems: "center",
    paddingVertical: 24,
  },
  versionText: {
    color: "#999",
    fontSize: 12,
    marginVertical: 2,
  },
});
