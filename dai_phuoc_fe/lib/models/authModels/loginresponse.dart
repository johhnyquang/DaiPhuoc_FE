class LoginResponse {
  final String refreshToken;
  final String accessToken;
  final DateTime refreshTokenExpiryTime;
  final int id;
  final String role;

  LoginResponse({
    required this.refreshToken,
    required this.accessToken,
    required this.refreshTokenExpiryTime,
    required this.id,
    required this.role
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json)
  {
    return LoginResponse(
      refreshToken: json['refreshToken'] ?? '',
      accessToken: json['accessToken'] ?? '',
      refreshTokenExpiryTime: DateTime.parse(json['refreshTokenExpiryTime']),
      id: json['id'] ?? 0,
      role: json['role'] ?? ''
    );
  }
}