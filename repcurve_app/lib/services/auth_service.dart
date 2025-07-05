import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/api_response.dart';
import '../models/user.dart';

class AuthService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  
  // Storage keys
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
  };

  static Future<Map<String, String>> get authHeaders async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token',
    };
  }

  // Token management
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<void> removeToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // User data management
  static Future<User?> getCurrentUser() async {
    final userData = await _storage.read(key: _userKey);
    if (userData != null) {
      try {
        return User.fromJson(json.decode(userData));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static Future<void> saveUser(User user) async {
    await _storage.write(key: _userKey, value: json.encode(user.toJson()));
  }

  static Future<void> removeUser() async {
    await _storage.delete(key: _userKey);
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Login
  static Future<ApiResponse<AuthResponse>> login(LoginRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login/'),
        headers: headers,
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final authResponse = AuthResponse.fromJson(data);
        
        // Save token and user data
        await saveToken(authResponse.token);
        await saveUser(authResponse.user);
        
        return ApiResponse.success(authResponse);
      } else {
        final errorData = json.decode(response.body);
        return ApiResponse.error(
          errorData['detail'] ?? 'Login failed',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  // Register
  static Future<ApiResponse<AuthResponse>> register(RegisterRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register/'),
        headers: headers,
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        final authResponse = AuthResponse.fromJson(data);
        
        // Save token and user data
        await saveToken(authResponse.token);
        await saveUser(authResponse.user);
        
        return ApiResponse.success(authResponse);
      } else {
        final errorData = json.decode(response.body);
        String errorMessage = 'Registration failed';
        
        // Handle field-specific errors
        if (errorData is Map) {
          List<String> errors = [];
          errorData.forEach((key, value) {
            if (value is List) {
              errors.addAll(value.map((e) => '$key: $e'));
            } else {
              errors.add('$key: $value');
            }
          });
          errorMessage = errors.join('\n');
        }
        
        return ApiResponse.error(
          errorMessage,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  // Logout
  static Future<ApiResponse<bool>> logout() async {
    try {
      final token = await getToken();
      if (token != null) {
        final response = await http.post(
          Uri.parse('$baseUrl/auth/logout/'),
          headers: await authHeaders,
        );
        
        // Remove stored data regardless of response
        await removeToken();
        await removeUser();
        
        if (response.statusCode == 200) {
          return ApiResponse.success(true);
        } else {
          return ApiResponse.success(true); // Still successful locally
        }
      } else {
        return ApiResponse.success(true);
      }
    } catch (e) {
      // Remove stored data even if network fails
      await removeToken();
      await removeUser();
      return ApiResponse.success(true);
    }
  }

  // Get user profile (refresh user data)
  static Future<ApiResponse<User>> getProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/profile/'),
        headers: await authHeaders,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final user = User.fromJson(data);
        
        // Update stored user data
        await saveUser(user);
        
        return ApiResponse.success(user);
      } else {
        return ApiResponse.error(
          'Failed to get profile',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }
}