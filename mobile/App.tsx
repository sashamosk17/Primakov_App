/* 
 * Responsibilities:
 * - Redux store initialization
 * - Root navigator setup
 * - Error boundary for crash handling
 * - Splash screen management
 */

import React, { useEffect, useState } from "react";
import { Provider } from "react-redux";
import { store } from "./src/redux/store";
import { RootNavigator } from "./src/navigation/RootNavigator";
import { View, ActivityIndicator, StatusBar, Text } from "react-native";
import * as SplashScreen from "expo-splash-screen";

// Оставляем заставку видимой во время загрузки ресурсов
SplashScreen.preventAutoHideAsync();

// Catches JS errors anywhere in the child component tree
 
interface ErrorBoundaryState {
  hasError: boolean;
  error: Error | null;
}

interface ErrorBoundaryProps {
  children: React.ReactNode;
}

class ErrorBoundary extends React.Component<ErrorBoundaryProps, ErrorBoundaryState> {
  constructor(props: ErrorBoundaryProps) {
    super(props);
    this.state = { hasError: false, error: null };
  }

  static getDerivedStateFromError(error: Error) {
    return { hasError: true, error };
  }

  componentDidCatch(error: Error, errorInfo: React.ErrorInfo) {
    console.error("App Error:", error, errorInfo);
  }

  render() {
    if (this.state.hasError) {
      return (
        <View style={{ flex: 1, justifyContent: "center", alignItems: "center", backgroundColor: "#fff" }}>
          <View style={{ alignItems: "center" }}>
            <View style={{ width: 80, height: 80, borderRadius: 40, backgroundColor: "#f44336", justifyContent: "center", alignItems: "center", marginBottom: 16 }}>
              <View style={{ width: 40, height: 40, backgroundColor: "white", borderRadius: 20 }} />
            </View>
            <Text style={{ fontSize: 18, fontWeight: "600", color: "#333", marginBottom: 8, textAlign: "center" }}>Ошибка в приложении</Text>
            <Text style={{ fontSize: 14, color: "#666", textAlign: "center", paddingHorizontal: 20 }}>
              {this.state.error?.message}
            </Text>
          </View>
        </View>
      );
    }

    return this.props.children;
  }
}

// Handles splash screen and app initialization
const AppContent = () => {
  const [isReady, setIsReady] = useState(false);

  useEffect(() => {
    const prepare = async () => {
      try {
        // Здесь можно добавить любые задачи инициализации (загрузка шрифтов, кэширование данных и т. д.)
        await new Promise((resolve) => setTimeout(resolve, 500));
      } catch (e) {
        console.warn(e);
      } finally {
        setIsReady(true);
        await SplashScreen.hideAsync();
      }
    };

    prepare();
  }, []);

  if (!isReady) {
    return (
      <View style={{ flex: 1, justifyContent: "center", alignItems: "center", backgroundColor: "#1976d2" }}>
        <ActivityIndicator size="large" color="#fff" />
      </View>
    );
  }

  return <RootNavigator />;
};

export default function App() {
  return (
    <ErrorBoundary>
      <StatusBar barStyle="light-content" backgroundColor="#1976d2" />
      <Provider store={store}>
        <AppContent />
      </Provider>
    </ErrorBoundary>
  );
}
