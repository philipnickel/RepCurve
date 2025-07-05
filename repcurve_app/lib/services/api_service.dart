import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_response.dart';
import '../models/workout.dart' hide Exercise;
import '../models/workout_models.dart';
import 'auth_service.dart';

class ApiService {
  // Development URLs
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  
  // For testing on physical device, use your computer's IP address
  // static const String baseUrl = 'http://192.168.1.XXX:8000/api';
  
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  // Health check endpoint
  static Future<ApiResponse<ApiHealth>> checkHealth() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/health/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ApiResponse.success(ApiHealth.fromJson(data));
      } else {
        return ApiResponse.error(
          'Health check failed',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  // API info endpoint
  static Future<ApiResponse<ApiInfo>> getApiInfo() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/info/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ApiResponse.success(ApiInfo.fromJson(data));
      } else {
        return ApiResponse.error(
          'Failed to get API info',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  // Future workout endpoints (to be implemented when Django models are ready)
  static Future<ApiResponse<List<Workout>>> getWorkouts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/workouts/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final workouts = (data['results'] as List)
            .map((w) => Workout.fromJson(w))
            .toList();
        return ApiResponse.success(workouts);
      } else {
        return ApiResponse.error(
          'Failed to get workouts',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  static Future<ApiResponse<Workout>> createWorkout(Workout workout) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/workouts/'),
        headers: headers,
        body: json.encode(workout.toJson()),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return ApiResponse.success(Workout.fromJson(data));
      } else {
        return ApiResponse.error(
          'Failed to create workout',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  static Future<ApiResponse<Workout>> updateWorkout(Workout workout) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/workouts/${workout.id}/'),
        headers: headers,
        body: json.encode(workout.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ApiResponse.success(Workout.fromJson(data));
      } else {
        return ApiResponse.error(
          'Failed to update workout',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  static Future<ApiResponse<bool>> deleteWorkout(int workoutId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/workouts/$workoutId/'),
        headers: headers,
      );

      if (response.statusCode == 204) {
        return ApiResponse.success(true);
      } else {
        return ApiResponse.error(
          'Failed to delete workout',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  // Exercise endpoints
  static Future<ApiResponse<List<Exercise>>> getExercises() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/exercises/'),
        headers: await AuthService.authHeaders,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final exercises = (data['results'] as List)
            .map((e) => Exercise.fromJson(e))
            .toList();
        return ApiResponse.success(exercises);
      } else {
        return ApiResponse.error(
          'Failed to get exercises',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  // Workout Template endpoints
  static Future<ApiResponse<List<WorkoutTemplate>>> getWorkoutTemplates() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/workout-templates/'),
        headers: await AuthService.authHeaders,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final templates = (data['results'] as List)
            .map((t) => WorkoutTemplate.fromJson(t))
            .toList();
        return ApiResponse.success(templates);
      } else {
        return ApiResponse.error(
          'Failed to get workout templates',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  static Future<ApiResponse<WorkoutTemplate>> createWorkoutTemplate(WorkoutTemplate template) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/workout-templates/'),
        headers: await AuthService.authHeaders,
        body: json.encode(template.toJson()),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return ApiResponse.success(WorkoutTemplate.fromJson(data));
      } else {
        return ApiResponse.error(
          'Failed to create workout template',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  // Scheduled Workout endpoints
  static Future<ApiResponse<List<ScheduledWorkout>>> getScheduledWorkouts({
    String? startDate,
    String? endDate,
  }) async {
    try {
      String url = '$baseUrl/scheduled-workouts/';
      List<String> queryParams = [];
      
      if (startDate != null) queryParams.add('start_date=$startDate');
      if (endDate != null) queryParams.add('end_date=$endDate');
      
      if (queryParams.isNotEmpty) {
        url += '?${queryParams.join('&')}';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: await AuthService.authHeaders,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final workouts = (data['results'] as List)
            .map((w) => ScheduledWorkout.fromJson(w))
            .toList();
        return ApiResponse.success(workouts);
      } else {
        return ApiResponse.error(
          'Failed to get scheduled workouts',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  static Future<ApiResponse<ScheduledWorkout>> createScheduledWorkout(ScheduledWorkout workout) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/scheduled-workouts/'),
        headers: await AuthService.authHeaders,
        body: json.encode(workout.toJson()),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return ApiResponse.success(ScheduledWorkout.fromJson(data));
      } else {
        return ApiResponse.error(
          'Failed to create scheduled workout',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  // Calendar endpoint
  static Future<ApiResponse<List<ScheduledWorkout>>> getCalendarWorkouts({
    int? year,
    int? month,
  }) async {
    try {
      String url = '$baseUrl/calendar/';
      List<String> queryParams = [];
      
      if (year != null) queryParams.add('year=$year');
      if (month != null) queryParams.add('month=$month');
      
      if (queryParams.isNotEmpty) {
        url += '?${queryParams.join('&')}';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: await AuthService.authHeaders,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final workouts = (data as List)
            .map((w) => ScheduledWorkout.fromJson(w))
            .toList();
        return ApiResponse.success(workouts);
      } else {
        return ApiResponse.error(
          'Failed to get calendar workouts',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  // Workout Log endpoints
  static Future<ApiResponse<List<WorkoutLog>>> getWorkoutLogs() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/workout-logs/'),
        headers: await AuthService.authHeaders,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final logs = (data['results'] as List)
            .map((l) => WorkoutLog.fromJson(l))
            .toList();
        return ApiResponse.success(logs);
      } else {
        return ApiResponse.error(
          'Failed to get workout logs',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }
}