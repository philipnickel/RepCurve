class Workout {
  final int? id;
  final String name;
  final DateTime date;
  final List<Exercise> exercises;
  final String? notes;

  Workout({
    this.id,
    required this.name,
    required this.date,
    required this.exercises,
    this.notes,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'],
      name: json['name'],
      date: DateTime.parse(json['date']),
      exercises: (json['exercises'] as List)
          .map((e) => Exercise.fromJson(e))
          .toList(),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'notes': notes,
    };
  }
}

class Exercise {
  final int? id;
  final String name;
  final List<Set> sets;
  final String? notes;

  Exercise({
    this.id,
    required this.name,
    required this.sets,
    this.notes,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      sets: (json['sets'] as List).map((s) => Set.fromJson(s)).toList(),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sets': sets.map((s) => s.toJson()).toList(),
      'notes': notes,
    };
  }
}

class Set {
  final int? id;
  final int reps;
  final double weight;
  final int? rpe; // Rate of Perceived Exertion (1-10)
  final String? notes;

  Set({
    this.id,
    required this.reps,
    required this.weight,
    this.rpe,
    this.notes,
  });

  factory Set.fromJson(Map<String, dynamic> json) {
    return Set(
      id: json['id'],
      reps: json['reps'],
      weight: json['weight'].toDouble(),
      rpe: json['rpe'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reps': reps,
      'weight': weight,
      'rpe': rpe,
      'notes': notes,
    };
  }

  // Calculate 1RM using Epley formula
  double get oneRepMax {
    return weight * (1 + reps / 30);
  }
}