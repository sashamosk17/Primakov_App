# PrimakovApp

Кроссплатформенное мобильное приложение для Гимназии им. Примакова.

- **Backend**: Node.js + Express + TypeScript, Clean Architecture / DDD, PostgreSQL
- **Frontend**: Flutter (Riverpod, Dio)

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

## Структура репозитория

```
PrimakovApp/
├── backend/          # Node.js/Express API (Clean Architecture)
├── flutter/          # Flutter мобильное приложение
├── images/           # UI-скриншоты и описания
├── stitch/           # Дизайн-материалы
└── .claude/docs/     # Подробная документация
```

## Документация

| Документ | Описание |
|----------|----------|
| [.claude/docs/README.md](.claude/docs/README.md) | Навигация по всей документации |
| [.claude/docs/general/architecture.md](.claude/docs/general/architecture.md) | Архитектура системы |
| [.claude/docs/backend/backend.md](.claude/docs/backend/backend.md) | Backend структура и слои |
| [.claude/docs/backend/api.md](.claude/docs/backend/api.md) | API Reference |
| [.claude/docs/backend/database.md](.claude/docs/backend/database.md) | Схема PostgreSQL БД |
| [.claude/docs/frontend/frontend.md](.claude/docs/frontend/frontend.md) | Flutter приложение |
| [.claude/docs/frontend/design-system.md](.claude/docs/frontend/design-system.md) | Дизайн-система |
| [ROADMAP.md](ROADMAP.md) | План развития и текущий статус |
| [CHANGELOG.md](CHANGELOG.md) | История изменений |
| [PROJECT_VISION.md](PROJECT_VISION.md) | Цели и концепция проекта |
| [DATABASE_DESIGN.md](DATABASE_DESIGN.md) | Подробная схема БД v3 |

## Демо-данные

Тестовые пользователи (пароль: `password123`):

- `ivan.petrov@primakov.school` — Ученик (10А)
- `teacher.ivanov@primakov.school` — Учитель
- `admin@primakov.school` — Администратор
