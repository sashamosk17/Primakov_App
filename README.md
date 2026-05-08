# PrimakovApp

Кроссплатформенное мобильное приложение для Гимназии им. Примакова.

- **Backend**: Node.js + Express + TypeScript, Clean Architecture / DDD, PostgreSQL
- **Frontend**: Flutter (Riverpod, Dio, url_launcher)
- **Фичи**: Аутентификация, расписание, дедлайны, Stories с фотографиями и гиперссылками, рейтинги учителей

## Быстрый старт

### Backend

```bash
cd backend
npm install
npm run dev
```

Сервер запустится на `http://localhost:3000`.  
Требует PostgreSQL — настройте `.env` (см. `backend/.env.example`).

### Flutter

```bash
cd flutter
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```
