class ApiResponse<T> {
  final bool success;
  final String apiversion;
  final String message;
  T? value;

  ApiResponse({
    required this.success,
    required this.apiversion,
    required this.message,
    this.value
  });

  Map<String, dynamic> toJson(){
    return{
      "success": success,
      "apiversion": apiversion,
      "message": message,
      "data": value
    };
  }

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool,
      apiversion: json['apiversion'] ?? '',
      message: json['message'] ?? '',
      value: fromJsonT != null && json['data'] != null 
        ? fromJsonT(json['data']) 
        : null,
    );
  }
}