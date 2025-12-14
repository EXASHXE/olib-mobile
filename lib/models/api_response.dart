// Simple API response wrapper without json_serializable
// (Generic types don't work well with json_serializable)
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final String? error;

  const ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool,
      data: fromJsonT != null && json['data'] != null
          ? fromJsonT(json['data'])
          : null,
      message: json['message'] as String?,
      error: json['error'] as String?,
    );
  }

  Map<String, dynamic> toJson(Object? Function(T)? toJsonT) {
    return {
      'success': success,
      'data': toJsonT != null && data != null ? toJsonT(data as T) : data,
      'message': message,
      'error': error,
    };
  }
}
