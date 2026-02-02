import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig
{
  // Singleton pattern
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
  AppConfig._internal();

  String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? '';
}