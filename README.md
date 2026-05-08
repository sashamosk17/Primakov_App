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
| **Backend** | |
| [.claude/docs/backend/architecture.md](.claude/docs/backend/architecture.md) | Clean Architecture, C4 диаграммы, слои |
| [.claude/docs/backend/api.md](.claude/docs/backend/api.md) | API Reference (10 модулей, 30+ endpoints) |
| [.claude/docs/backend/database.md](.claude/docs/backend/database.md) | PostgreSQL схема (11 таблиц, ER-диаграмма) |
| [.claude/docs/backend/dependencies.md](.claude/docs/backend/dependencies.md) | NPM зависимости и граф зависимостей |
| [.claude/docs/backend/deployment.md](.claude/docs/backend/deployment.md) | Production deployment (Docker, PM2, nginx) |
| [.claude/docs/backend/testing.md](.claude/docs/backend/testing.md) | Тестирование (Unit, Integration, API) |
| **Frontend** | |
| [.claude/docs/frontend/README.md](.claude/docs/frontend/README.md) | Flutter документация (навигация) |
| [.claude/docs/frontend/architecture.md](.claude/docs/frontend/architecture.md) | Riverpod архитектура, слои, паттерны |
| [.claude/docs/frontend/navigation.md](.claude/docs/frontend/navigation.md) | Навигация (21 экран, flow диаграммы) |
| [.claude/docs/frontend/state-management.md](.claude/docs/frontend/state-management.md) | State Management (11 providers, StateNotifier) |
| [.claude/docs/frontend/api-integration.md](.claude/docs/frontend/api-integration.md) | API интеграция (10 сервисов, 100% покрытие) |
| **Общее** | |
| [ROADMAP.md](ROADMAP.md) | План развития и текущий статус |
| [CHANGELOG.md](CHANGELOG.md) | История изменений |
| [PROJECT_VISION.md](PROJECT_VISION.md) | Цели и концепция проекта |
| [DATABASE_DESIGN.md](DATABASE_DESIGN.md) | Подробная схема БД v3 |

## Что нового (v0.2.4)

### 📚 Полная документация проекта

**Добавлено 4 мая 2026 года**

- 📖 **Документация бэкенда**: 8 файлов, 12,000+ строк
  - Clean Architecture с C4 диаграммами
  - API Reference (10 модулей, 30+ endpoints)
  - PostgreSQL схема с ER-диаграммой
  - Deployment, Testing, Dependencies
  
- 📱 **Документация фронтенда**: 5 файлов, 10,000+ строк
  - Riverpod архитектура с диаграммами
  - Навигация (21 экран, flow диаграммы)
  - State Management (11 providers)
  - API интеграция (100% покрытие бэкенда)
  
- 🎨 **Диаграммы**: 15+ Mermaid диаграмм
  - C4 (Context, Container, Component)
  - ER-диаграмма базы данных
  - Navigation flow, State management
  - Sequence diagrams, Class diagrams

### 🎉 Stories Enhancement: Фотографии и гиперссылки

**Добавлено 2 мая 2026 года**

- 📸 **Фотографии в Stories**: Истории теперь отображают реальные изображения вместо иконок
- 🔗 **Гиперссылки**: Кнопка "Подробнее" открывает новости на primakov.school во внешнем браузере
- 🎨 **Улучшенный дизайн**: Красивые карточки с тенями, анимациями и fallback для ошибок загрузки
- 📱 **Новые истории**: 
  - "30-я юбилейная конференция «Санкт-Петербургская Модель ООН»"
  - "Встреча, после которой космос уже не кажется далёким"

**Технические изменения:**
- Добавлены поля `linkUrl` и `linkText` в Story модель
- Обновлены миграции БД и репозитории
- Интегрирован `url_launcher` для открытия внешних ссылок
- Исправлены проблемы с Riverpod state mutation

## Демо-данные

Тестовые пользователи (пароль: `password123`):

- `ivan.petrov@primakov.school` — Ученик (10А)
- `teacher.ivanov@primakov.school` — Учитель
- `admin@primakov.school` — Администратор
