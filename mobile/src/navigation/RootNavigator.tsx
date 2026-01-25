/**
 * RootNavigator
 * Main navigation orchestrator handling auth flow with bottom tabs
 */

import React from "react";
import { Text, View } from "react-native";
import { NavigationContainer } from "@react-navigation/native";
import { createNativeStackNavigator } from "@react-navigation/native-stack";
import { createBottomTabNavigator } from "@react-navigation/bottom-tabs";
import { useSelector } from "react-redux";
import { RootState } from "../redux/store";

// Auth Screens
import { LoginScreen } from "../screens/AuthStack/LoginScreen";
import { RegisterScreen } from "../screens/AuthStack/RegisterScreen";

// Main Screens
import { ScheduleScreen } from "../screens/MainStack/ScheduleScreen";
import { DeadlineScreen } from "../screens/MainStack/DeadlineScreen";
import { ProfileScreen } from "../screens/MainStack/ProfileScreen";

const Stack = createNativeStackNavigator();
const Tab = createBottomTabNavigator();

/**
 * AuthNavigator Stack
 */
const AuthNavigator = () => {
  return (
    <Stack.Navigator
      screenOptions={{
        headerShown: false,
        cardStyle: { backgroundColor: "white" },
      }}
    >
      <Stack.Screen name="Login" component={LoginScreen} />
      <Stack.Screen name="Register" component={RegisterScreen} />
    </Stack.Navigator>
  );
};

/**
 * MainNavigator with Bottom Tabs
 */
const MainNavigator = () => {
  return (
    <Tab.Navigator
      screenOptions={{
        headerShown: true,
        headerStyle: { backgroundColor: "#1976d2" },
        headerTintColor: "white",
        headerTitleStyle: { fontWeight: "bold" },
        tabBarActiveTintColor: "#1976d2",
        tabBarInactiveTintColor: "#999",
        tabBarStyle: {
          backgroundColor: "white",
          borderTopWidth: 1,
          borderTopColor: "#eee",
          paddingBottom: 8,
          paddingTop: 8,
          height: 64,
        },
      }}
    >
      <Tab.Screen
        name="ScheduleTab"
        component={ScheduleScreen}
        options={{
          title: "Расписание",
          tabBarLabel: "Расписание",
          tabBarIcon: ({ color }) => <Text style={{ fontSize: 18, color }}>📚</Text>,
        }}
      />
      <Tab.Screen
        name="DeadlinesTab"
        component={DeadlineScreen}
        options={{
          title: "Дедлайны",
          tabBarLabel: "Дедлайны",
          tabBarIcon: ({ color }) => <Text style={{ fontSize: 18, color }}>⏰</Text>,
        }}
      />
      <Tab.Screen
        name="ProfileTab"
        component={ProfileScreen}
        options={{
          title: "Профиль",
          tabBarLabel: "Профиль",
          tabBarIcon: ({ color }) => <Text style={{ fontSize: 18, color }}>👤</Text>,
        }}
      />
    </Tab.Navigator>
  );
};

/**
 * RootNavigator Component
 * Handles conditional rendering based on auth state
 */
export const RootNavigator = () => {
  const userId = useSelector((state: RootState) => state.auth.userId);
  const isLoggedIn = !!userId;

  return (
    <NavigationContainer>
      <Stack.Navigator screenOptions={{ headerShown: false }}>
        {isLoggedIn ? (
          <Stack.Screen
            name="Main"
            component={MainNavigator}
            options={{ animationEnabled: false }}
          />
        ) : (
          <Stack.Screen
            name="Auth"
            component={AuthNavigator}
            options={{ animationEnabled: false }}
          />
        )}
      </Stack.Navigator>
    </NavigationContainer>
  );
};
