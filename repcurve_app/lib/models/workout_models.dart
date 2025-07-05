class Exercise {
  final int? id;
  final String name;
  final String category;
  final String description;
  final DateTime? createdAt;

  Exercise({
    this.id,
    required this.name,
    required this.category,
    this.description = '',
    this.createdAt,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      description: json['description'] ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}

class TemplateExercise {
  final int? id;
  final int exerciseId;
  final String exerciseName;
  final String exerciseCategory;
  final int targetSets;
  final int targetReps;
  final double? targetWeight;
  final int restSeconds;
  final String notes;
  final int order;

  TemplateExercise({
    this.id,
    required this.exerciseId,
    required this.exerciseName,
    required this.exerciseCategory,
    required this.targetSets,
    required this.targetReps,
    this.targetWeight,
    this.restSeconds = 180,
    this.notes = '',
    this.order = 0,
  });

  factory TemplateExercise.fromJson(Map<String, dynamic> json) {
    return TemplateExercise(
      id: json['id'],
      exerciseId: json['exercise'],
      exerciseName: json['exercise_name'] ?? '',
      exerciseCategory: json['exercise_category'] ?? '',
      targetSets: json['target_sets'],
      targetReps: json['target_reps'],
      targetWeight: json['target_weight']?.toDouble(),
      restSeconds: json['rest_seconds'] ?? 180,
      notes: json['notes'] ?? '',
      order: json['order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exercise': exerciseId,
      'target_sets': targetSets,
      'target_reps': targetReps,
      'target_weight': targetWeight,
      'rest_seconds': restSeconds,
      'notes': notes,
      'order': order,
    };
  }
}

class WorkoutTemplate {
  final int? id;
  final String name;
  final String description;
  final List<TemplateExercise> templateExercises;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  WorkoutTemplate({
    this.id,
    required this.name,
    this.description = '',
    this.templateExercises = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory WorkoutTemplate.fromJson(Map<String, dynamic> json) {
    return WorkoutTemplate(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      templateExercises: (json['template_exercises'] as List? ?? [])
          .map((e) => TemplateExercise.fromJson(e))
          .toList(),
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class ScheduledWorkout {
  final int? id;
  final int templateId;
  final String templateName;
  final WorkoutTemplate? templateDetails;
  final DateTime scheduledDate;
  final String notes;
  final bool isCompleted;
  final DateTime? createdAt;

  ScheduledWorkout({
    this.id,
    required this.templateId,
    required this.templateName,
    this.templateDetails,
    required this.scheduledDate,
    this.notes = '',
    this.isCompleted = false,
    this.createdAt,
  });

  factory ScheduledWorkout.fromJson(Map<String, dynamic> json) {
    return ScheduledWorkout(
      id: json['id'],
      templateId: json['template'],
      templateName: json['template_name'] ?? '',
      templateDetails: json['template_details'] != null 
          ? WorkoutTemplate.fromJson(json['template_details'])
          : null,
      scheduledDate: DateTime.parse(json['scheduled_date']),
      notes: json['notes'] ?? '',
      isCompleted: json['is_completed'] ?? false,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'template': templateId,
      'scheduled_date': scheduledDate.toIso8601String().split('T')[0], // Date only
      'notes': notes,
      'is_completed': isCompleted,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}

class SetLog {
  final int? id;
  final int setNumber;
  final int reps;
  final double weight;
  final int? rpe;
  final String notes;

  SetLog({
    this.id,
    required this.setNumber,
    required this.reps,
    required this.weight,
    this.rpe,
    this.notes = '',
  });

  factory SetLog.fromJson(Map<String, dynamic> json) {
    return SetLog(
      id: json['id'],
      setNumber: json['set_number'],
      reps: json['reps'],
      weight: json['weight'].toDouble(),
      rpe: json['rpe'],
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'set_number': setNumber,
      'reps': reps,
      'weight': weight,
      'rpe': rpe,
      'notes': notes,
    };
  }

  double get estimatedOneRM {
    return weight * (1 + reps / 30);
  }
}

class ExerciseLog {
  final int? id;
  final int exerciseId;
  final String exerciseName;
  final List<SetLog> setLogs;
  final String notes;
  final int order;

  ExerciseLog({
    this.id,
    required this.exerciseId,
    required this.exerciseName,
    this.setLogs = const [],
    this.notes = '',
    this.order = 0,
  });

  factory ExerciseLog.fromJson(Map<String, dynamic> json) {
    return ExerciseLog(
      id: json['id'],
      exerciseId: json['exercise'],
      exerciseName: json['exercise_name'] ?? '',
      setLogs: (json['set_logs'] as List? ?? [])
          .map((e) => SetLog.fromJson(e))
          .toList(),
      notes: json['notes'] ?? '',
      order: json['order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exercise': exerciseId,
      'notes': notes,
      'order': order,
    };
  }
}

class WorkoutLog {
  final int? id;
  final int? scheduledWorkoutId;
  final String workoutName;
  final DateTime date;
  final int? durationMinutes;
  final String notes;
  final List<ExerciseLog> exerciseLogs;
  final DateTime? createdAt;

  WorkoutLog({
    this.id,
    this.scheduledWorkoutId,
    required this.workoutName,
    required this.date,
    this.durationMinutes,
    this.notes = '',
    this.exerciseLogs = const [],
    this.createdAt,
  });

  factory WorkoutLog.fromJson(Map<String, dynamic> json) {
    return WorkoutLog(
      id: json['id'],
      scheduledWorkoutId: json['scheduled_workout'],
      workoutName: json['workout_name'],
      date: DateTime.parse(json['date']),
      durationMinutes: json['duration_minutes'],
      notes: json['notes'] ?? '',
      exerciseLogs: (json['exercise_logs'] as List? ?? [])
          .map((e) => ExerciseLog.fromJson(e))
          .toList(),
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scheduled_workout': scheduledWorkoutId,
      'workout_name': workoutName,
      'date': date.toIso8601String(),
      'duration_minutes': durationMinutes,
      'notes': notes,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}