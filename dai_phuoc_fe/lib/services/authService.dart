import 'dart:convert';
import 'package:dai_phuoc_fe/models/apiresponse.dart';
import 'package:dai_phuoc_fe/models/authModels/loginresponse.dart';
import 'package:dai_phuoc_fe/models/authModels/register.dart';
import 'package:dai_phuoc_fe/models/authModels/loginrequest.dart';
import 'package:dai_phuoc_fe/models/authModels/rotationmodel.dart';
import 'package:dai_phuoc_fe/utils/app_config.dart';
import 'package:dai_phuoc_fe/utils/status_code.dart';
import 'package:http/http.dart' as http;

class AuthService 
{
  final AppConfig _config = AppConfig();
  static const String model = "Auth";

  ApiResponse<LoginResponse> _responseHelper(ApiResponse<LoginResponse> dataResponse, http.Response response){
      if (response.statusCode == StatusCode.created) 
      {
        if (dataResponse.success == true && dataResponse.value != null)
        {
          return dataResponse;
        }
        else
        {
          throw Exception(dataResponse.message);
        }
      }
      if (response.statusCode == StatusCode.ok) {
        if (dataResponse.success == true && dataResponse.value != null)
        {
          return dataResponse;
        }
        else
        {
          throw Exception(dataResponse.message);
        }
      }
      else if (response.statusCode == StatusCode.internalServerError)
      {
        throw Exception('Lỗi server: ${dataResponse.message}');
      }
      else
      {
        throw Exception('Lỗi không xác định ${dataResponse.message}');
      }
  }

  Future<ApiResponse<LoginResponse>> registerAsync(Register register) async{
    try {
      final Uri uri = Uri.parse('${_config.apiBaseUrl}/$model/Register');

      final body = register.toJson();

      final response = await http.post(
        uri,
        body: jsonEncode(body),
        headers: {"Content-Type": "application/json"}
      );
      
      Map<String, dynamic> jsonMap = jsonDecode(response.body);
      ApiResponse<LoginResponse> jsonResponse = ApiResponse.fromJson(
        jsonMap,
        (data){
          return LoginResponse.fromJson(data);
        }
      );
      
      return _responseHelper(jsonResponse, response);

    } catch (e) {
      return ApiResponse(success: false, apiversion: "V1", message: 'Lỗi khi gọi API $e');
    }
  }

  Future<ApiResponse<LoginResponse>> loginAsync(LoginRequest loginRequest) async
  {
    try {
      final Uri uri = Uri.parse('${_config.apiBaseUrl}/$model/Login');

      final response = await http.post(
        uri,
        body: jsonEncode(loginRequest.toJson()),
        headers: {"Content-Type": "application/json"}
      );

      Map<String, dynamic> jsonMap = jsonDecode(response.body);
      ApiResponse<LoginResponse> jsonResponse = ApiResponse.fromJson(
        jsonMap,
        (data){
          return LoginResponse.fromJson(data);
        }
      );

      return _responseHelper(jsonResponse, response);
    } catch (e) {
      return ApiResponse(success: false, apiversion: "V1", message: 'Lỗi khi gọi API $e');
    }
  }

  Future<ApiResponse<LoginResponse>> refreshToken(RotationModel rotationmodel) async{
    try {
      final Uri uri = Uri.parse('${_config.apiBaseUrl}/$model/Refresh');
      
      final response = await http.post(
        uri,
        body: jsonEncode(rotationmodel.toJson()),
        headers: {"Content-Type": "application/json"}
      );

      Map<String, dynamic> jsonMap = jsonDecode(response.body);
      ApiResponse<LoginResponse> jsonResponse = ApiResponse.fromJson(
        jsonMap,
        (data){
          return LoginResponse.fromJson(data);
        }
      );

      return _responseHelper(jsonResponse, response);
    } catch (e) {
      // throw Exception('Lỗi khi gọi API $e');
      return ApiResponse(success: false, apiversion: "V1", message: 'Lỗi khi gọi API $e');
    }
  }
}
