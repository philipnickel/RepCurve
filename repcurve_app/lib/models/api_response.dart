class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;
  final int? statusCode;

  ApiResponse({
    required this.success,
    this.data,
    this.error,
    this.statusCode,
  });

  factory ApiResponse.success(T data) {
    return ApiResponse(
      success: true,
      data: data,
    );
  }

  factory ApiResponse.error(String error, {int? statusCode}) {
    return ApiResponse(
      success: false,
      error: error,
      statusCode: statusCode,
    );
  }
}

class ApiHealth {
  final String status;
  final String message;

  ApiHealth({
    required this.status,
    required this.message,
  });

  factory ApiHealth.fromJson(Map<String, dynamic> json) {
    return ApiHealth(
      status: json['status'],
      message: json['message'],
    );
  }
}

class ApiInfo {
  final String name;
  final String version;
  final String description;

  ApiInfo({
    required this.name,
    required this.version,
    required this.description,
  });

  factory ApiInfo.fromJson(Map<String, dynamic> json) {
    return ApiInfo(
      name: json['name'],
      version: json['version'],
      description: json['description'],
    );
  }
}