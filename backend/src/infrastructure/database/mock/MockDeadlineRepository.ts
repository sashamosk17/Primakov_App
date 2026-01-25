/*
 * In-memory deadline repository with realistic deadlines
 * Contains 10 active deadlines across different subjects and groups
 */

import { Deadline } from "../../../domain/entities/Deadline";
import { IDeadlineRepository } from "../../../domain/repositories/IDeadlineRepository";
import { Result } from "../../../shared/Result";
import { DeadlineStatus } from "../../../domain/value-objects/DeadlineStatus";

export class MockDeadlineRepository implements IDeadlineRepository {
  private deadlines: Deadline[] = [];

  constructor() {
    this.initializeTestData();
  }

  private initializeTestData(): void {
    const userId = "user-1"; // For student user-1
    const today = new Date();

    const testDeadlines = [
      {
        title: "Эссе по Литературе",
        description: "Написать эссе на тему: 'Роль морали в романе Достоевского'",
        dueDate: new Date(today.getTime() + 4 * 24 * 60 * 60 * 1000),
        subject: "Литература",
      },
      {
        title: "Лабораторная работа по Физике",
        description: "Провести опыт по закону сохранения энергии и подготовить отчет",
        dueDate: new Date(today.getTime() + 2 * 24 * 60 * 60 * 1000),
        subject: "Физика",
      },
      {
        title: "Контрольная работа по Математике",
        description: "Пройти тест по производным и интегралам (10 задач)",
        dueDate: new Date(today.getTime() + 1 * 24 * 60 * 60 * 1000),
        subject: "Математика",
      },
      {
        title: "Проект по Истории",
        description: "Создать презентацию о Российской Империи (XV-XVIII век)",
        dueDate: new Date(today.getTime() + 7 * 24 * 60 * 60 * 1000),
        subject: "История",
      },
      {
        title: "Тестирование по Английскому языку",
        description: "Пройти тест на использование Present Perfect и Past Simple",
        dueDate: new Date(today.getTime() + 3 * 24 * 60 * 60 * 1000),
        subject: "Английский язык",
      },
      {
        title: "Домашнее задание по Химии",
        description: "Решить задачи по расчету молярных масс веществ (стр. 234-235)",
        dueDate: new Date(today.getTime() + 1 * 24 * 60 * 60 * 1000),
        subject: "Химия",
      },
      {
        title: "Реферат по Обществознанию",
        description: "Написать реферат на тему 'Гражданское общество в России' (10-12 стр.)",
        dueDate: new Date(today.getTime() + 10 * 24 * 60 * 60 * 1000),
        subject: "Обществознание",
      },
      {
        title: "Программирование на Python",
        description: "Написать программу для сортировки массива (не менее 3 методов)",
        dueDate: new Date(today.getTime() + 5 * 24 * 60 * 60 * 1000),
        subject: "Информатика",
      },
      {
        title: "Творческий проект по Музыке",
        description: "Составить плей-лист из 10 произведений разных эпох с описанием",
        dueDate: new Date(today.getTime() + 8 * 24 * 60 * 60 * 1000),
        subject: "Музыка",
      },
      {
        title: "Доклад по Географии",
        description: "Подготовить доклад о климатических поясах Земли (5-7 минут)",
        dueDate: new Date(today.getTime() + 6 * 24 * 60 * 60 * 1000),
        subject: "География",
      },
    ];

    testDeadlines.forEach((deadline, index) => {
      this.deadlines.push(
        new Deadline(
          `deadline-${index + 1}`,
          deadline.title,
          deadline.description,
          deadline.dueDate,
          userId,
          DeadlineStatus.PENDING,
          new Date(today.getTime() - (10 - index) * 24 * 60 * 60 * 1000),
          undefined,
          undefined,
          deadline.subject
        )
      );
    });

    const completedDeadlines = [
      {
        title: "Презентация по Биологии",
        description: "Создать презентацию о системах органов человека",
        subject: "Биология",
      },
      {
        title: "Тест по Русскому языку",
        description: "Пройти тест на использование деепричастий",
        subject: "Русский язык",
      },
    ];

    completedDeadlines.forEach((deadline, index) => {
      const createdDate = new Date(today.getTime() - (15 + index) * 24 * 60 * 60 * 1000);
      const completedAt = new Date(createdDate.getTime() + 10 * 24 * 60 * 60 * 1000);

      this.deadlines.push(
        new Deadline(
          `deadline-completed-${index + 1}`,
          deadline.title,
          deadline.description,
          completedAt,
          userId,
          DeadlineStatus.COMPLETED,
          createdDate,
          new Date(),
          completedAt,
          deadline.subject
        )
      );
    });
  }

  async getByUser(userId: string): Promise<Result<Deadline[]>> {
    const userDeadlines = this.deadlines.filter((d) => d.userId === userId);
    return Result.ok(userDeadlines);
  }

  async save(deadline: Deadline): Promise<Result<void>> {
    this.deadlines.push(deadline);
    return Result.ok();
  }

  async update(deadline: Deadline): Promise<Result<void>> {
    const existingIndex = this.deadlines.findIndex((d) => d.id === deadline.id);
    if (existingIndex >= 0) {
      this.deadlines[existingIndex] = deadline;
    }
    return Result.ok();
  }
}
