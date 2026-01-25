/**
 * LoginScreen
 * Authentication screen for user login
 */

import React, { useState } from "react";
import { View, Text, StyleSheet, TouchableOpacity, TextInput, ScrollView } from "react-native";
import { useDispatch } from "react-redux";
import { AppDispatch } from "../../redux/store";
import { AuthService } from "../../api/AuthService";
import { setUserId, setToken, setUserRole } from "../../redux/slices/authSlice";

export const LoginScreen: React.FC<{ navigation: any }> = ({ navigation }) => {
  const dispatch = useDispatch<AppDispatch>();
  const [email, setEmail] = useState("ivan.petrov@primakov.school");
  const [password, setPassword] = useState("password123");
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleLogin = async () => {
    if (!email || !password) {
      setError("Пожалуйста, заполните все поля");
      return;
    }

    setIsLoading(true);
    setError(null);

    try {
      const response = await AuthService.login(email, password);
      dispatch(setUserId(response.user.id));
      dispatch(setToken(response.token));
      dispatch(setUserRole(response.user.role));
      // Note: localStorage is not available in React Native
      // Use AsyncStorage for native persistence in the future
    } catch (err: any) {
      setError(err.message || "Ошибка входа");
    } finally {
      setIsLoading(false);
    }
  };

  const handleRegister = () => {
    navigation.navigate("Register");
  };

  return (
    <ScrollView style={styles.container}>
      <View style={styles.content}>
        <Text style={styles.title}>PrimakovApp</Text>
        <Text style={styles.subtitle}>Вход в систему</Text>

        <View style={styles.form}>
          <TextInput
            style={styles.input}
            placeholder="Email"
            value={email}
            onChangeText={setEmail}
            editable={!isLoading}
            keyboardType="email-address"
            autoCapitalize="none"
            placeholderTextColor="#999"
          />

          <TextInput
            style={styles.input}
            placeholder="Пароль"
            value={password}
            onChangeText={setPassword}
            secureTextEntry
            editable={!isLoading}
            placeholderTextColor="#999"
          />

          {error && <Text style={styles.errorText}>{error}</Text>}

          <TouchableOpacity
            style={[styles.button, isLoading && styles.buttonDisabled]}
            onPress={handleLogin}
            disabled={isLoading}
          >
            <Text style={styles.buttonText}>
              {isLoading ? "Загрузка..." : "Войти"}
            </Text>
          </TouchableOpacity>

          <TouchableOpacity onPress={handleRegister} disabled={isLoading}>
            <Text style={styles.link}>Нет аккаунта? Зарегистрируйся</Text>
          </TouchableOpacity>
        </View>

        <Text style={styles.demoText}>
          Demo: ivan.petrov@primakov.school / password123
        </Text>
      </View>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#f5f5f5",
  },
  content: {
    padding: 20,
    justifyContent: "center",
    minHeight: "100%",
  },
  title: {
    fontSize: 32,
    fontWeight: "bold",
    textAlign: "center",
    marginBottom: 10,
    color: "#1976d2",
  },
  subtitle: {
    fontSize: 18,
    textAlign: "center",
    marginBottom: 30,
    color: "#666",
  },
  form: {
    backgroundColor: "white",
    borderRadius: 8,
    padding: 20,
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 3,
  },
  input: {
    borderWidth: 1,
    borderColor: "#ddd",
    borderRadius: 8,
    padding: 12,
    marginBottom: 16,
    fontSize: 16,
    color: "#333",
  },
  button: {
    backgroundColor: "#1976d2",
    borderRadius: 8,
    padding: 12,
    alignItems: "center",
    marginBottom: 16,
  },
  buttonDisabled: {
    opacity: 0.6,
  },
  buttonText: {
    color: "white",
    fontSize: 16,
    fontWeight: "600",
  },
  link: {
    color: "#1976d2",
    textAlign: "center",
    fontSize: 14,
  },
  errorText: {
    color: "#d32f2f",
    marginBottom: 12,
    fontSize: 14,
  },
  demoText: {
    marginTop: 30,
    textAlign: "center",
    color: "#999",
    fontSize: 12,
  },
});
