import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

enum AuthState {
  loading,
  authenticated,
  unauthenticated,
}

class AuthProvider with ChangeNotifier {
  AuthState _state = AuthState.loading;
  User? _user;
  String? _error;

  AuthState get state => _state;
  User? get user => _user;
  String? get error => _error;
  bool get isAuthenticated => _state == AuthState.authenticated;
  bool get isLoading => _state == AuthState.loading;

  Future<void> checkAuthStatus() async {
    _setState(AuthState.loading);
    
    try {
      final isLoggedIn = await AuthService.isLoggedIn();
      if (isLoggedIn) {
        final user = await AuthService.getCurrentUser();
        if (user != null) {
          _user = user;
          _setState(AuthState.authenticated);
        } else {
          _setState(AuthState.unauthenticated);
        }
      } else {
        _setState(AuthState.unauthenticated);
      }
    } catch (e) {
      _error = e.toString();
      _setState(AuthState.unauthenticated);
    }
  }

  Future<bool> login(String username, String password) async {
    _setState(AuthState.loading);
    _error = null;

    final request = LoginRequest(username: username, password: password);
    final response = await AuthService.login(request);

    if (response.success && response.data != null) {
      _user = response.data!.user;
      _setState(AuthState.authenticated);
      return true;
    } else {
      _error = response.error;
      _setState(AuthState.unauthenticated);
      return false;
    }
  }

  Future<bool> register({
    required String username,
    required String email,
    required String password,
    required String passwordConfirm,
    String firstName = '',
    String lastName = '',
  }) async {
    _setState(AuthState.loading);
    _error = null;

    final request = RegisterRequest(
      username: username,
      email: email,
      password: password,
      passwordConfirm: passwordConfirm,
      firstName: firstName,
      lastName: lastName,
    );

    final response = await AuthService.register(request);

    if (response.success && response.data != null) {
      _user = response.data!.user;
      _setState(AuthState.authenticated);
      return true;
    } else {
      _error = response.error;
      _setState(AuthState.unauthenticated);
      return false;
    }
  }

  Future<void> logout() async {
    _setState(AuthState.loading);
    
    await AuthService.logout();
    _user = null;
    _error = null;
    _setState(AuthState.unauthenticated);
  }

  Future<void> refreshProfile() async {
    if (_state != AuthState.authenticated) return;

    final response = await AuthService.getProfile();
    if (response.success && response.data != null) {
      _user = response.data;
      notifyListeners();
    }
  }

  void _setState(AuthState newState) {
    _state = newState;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}