/// API Models
/// Converted from TypeScript types/api.ts

class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final UserRole role;
  final bool isActive;
  final String? vkId;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.isActive,
    this.vkId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      role: UserRole.values.byName(json['role'] as String? ?? 'STUDENT'),
      isActive: json['isActive'] as bool? ?? true,
      vkId: json['vkId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'firstName': firstName,
    'lastName': lastName,
    'role': role.name,
    'isActive': isActive,
    'vkId': vkId,
  };
}

enum UserRole { STUDENT, TEACHER, ADMIN }

class Lesson {
  final String id;
  final String subject;
  final String teacherId;
  final String startTime;
  final String endTime;
  final String room;
  final int floor;
  final bool hasHomework;

  Lesson({
    required this.id,
    required this.subject,
    required this.teacherId,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.floor,
    required this.hasHomework,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    // Адаптер для формата бэкенда
    String startTime;
    String endTime;
    
    if (json['timeSlot'] != null) {
      startTime = json['timeSlot']['_startTime'] as String? ?? '';
      endTime = json['timeSlot']['_endTime'] as String? ?? '';
    } else {
      startTime = json['startTime'] as String? ?? '';
      endTime = json['endTime'] as String? ?? '';
    }
    
    String room;
    if (json['room'] != null && json['room'] is Map) {
      room = json['room']['_number'] as String? ?? '';
    } else {
      room = json['room'] as String? ?? '';
    }
    
    return Lesson(
      id: json['id'] as String,
      subject: json['subject'] as String,
      teacherId: json['teacherId'] as String,
      startTime: startTime,
      endTime: endTime,
      room: room,
      floor: json['floor'] as int? ?? 3,
      hasHomework: json['hasHomework'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'subject': subject,
    'teacherId': teacherId,
    'startTime': startTime,
    'endTime': endTime,
    'room': room,
    'floor': floor,
    'hasHomework': hasHomework,
  };
}

class Schedule {
  final String id;
  final String groupId;
  final String date;
  final List<Lesson> lessons;

  Schedule({
    required this.id,
    required this.groupId,
    required this.date,
    required this.lessons,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      date: json['date'] as String,
      lessons: (json['lessons'] as List<dynamic>?)
          ?.map((e) => Lesson.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'groupId': groupId,
    'date': date,
    'lessons': lessons.map((e) => e.toJson()).toList(),
  };
}

enum DeadlineStatus { PENDING, COMPLETED, OVERDUE }

class Deadline {
  final String id;
  final String title;
  final String description;
  final String dueDate;
  final String userId;
  final DeadlineStatus status;
  final String? subject;
  final String createdAt;
  final String? completedAt;

  Deadline({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.userId,
    required this.status,
    this.subject,
    required this.createdAt,
    this.completedAt,
  });

  factory Deadline.fromJson(Map<String, dynamic> json) {
    return Deadline(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      dueDate: json['dueDate'] as String,
      userId: json['userId'] as String,
      status: DeadlineStatus.values.byName(json['status'] as String? ?? 'PENDING'),
      subject: json['subject'] as String?,
      createdAt: json['createdAt'] as String,
      completedAt: json['completedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'dueDate': dueDate,
    'userId': userId,
    'status': status.name,
    'subject': subject,
    'createdAt': createdAt,
    'completedAt': completedAt,
  };
}

class Story {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String? videoUrl;
  final List<String> viewedBy;

  Story({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    this.videoUrl,
    required this.viewedBy,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      videoUrl: json['videoUrl'] as String?,
      viewedBy: List<String>.from(json['viewedBy'] as List<dynamic>? ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'imageUrl': imageUrl,
    'videoUrl': videoUrl,
    'viewedBy': viewedBy,
  };
}

class Rating {
  final String id;
  final String teacherId;
  final String studentId;
  final double rate;
  final String comment;
  final String createdAt;

  Rating({
    required this.id,
    required this.teacherId,
    required this.studentId,
    required this.rate,
    required this.comment,
    required this.createdAt,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'] as String,
      teacherId: json['teacherId'] as String,
      studentId: json['studentId'] as String,
      rate: (json['rate'] as num).toDouble(),
      comment: json['comment'] as String,
      createdAt: json['createdAt'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'teacherId': teacherId,
    'studentId': studentId,
    'rate': rate,
    'comment': comment,
    'createdAt': createdAt,
  };
}

class Announcement {
  final String id;
  final String title;
  final String content;
  final String createdAt;

  Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: json['createdAt'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'createdAt': createdAt,
  };
}

class News {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String createdAt;

  News({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.createdAt,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      createdAt: json['createdAt'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'imageUrl': imageUrl,
    'createdAt': createdAt,
  };
}

class Quote {
  final String id;
  final String text;
  final String author;

  Quote({
    required this.id,
    required this.text,
    required this.author,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'] as String,
      text: json['text'] as String,
      author: json['author'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'author': author,
  };
}

class CafeteriaInfo {
  final double balance;
  final String todayMenu;

  CafeteriaInfo({
    required this.balance,
    required this.todayMenu,
  });

  factory CafeteriaInfo.fromJson(Map<String, dynamic> json) {
    return CafeteriaInfo(
      balance: (json['balance'] as num).toDouble(),
      todayMenu: json['todayMenu'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'balance': balance,
    'todayMenu': todayMenu,
  };
}

class AuthResponse {
  final User user;
  final String token;

  AuthResponse({
    required this.user,
    required this.token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'user': user.toJson(),
    'token': token,
  };
}

class ApiResponse<T> {
  final String status;
  final T? data;
  final Map<String, dynamic>? error;

  ApiResponse({
    required this.status,
    this.data,
    this.error,
  });

  bool get isSuccess => status == 'success';
  bool get isError => status == 'error';

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse(
      status: json['status'] as String? ?? 'error',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : null,
      error: json['error'] as Map<String, dynamic>?,
    );
  }
}
