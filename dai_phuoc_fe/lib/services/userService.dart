import 'dart:convert';

import 'package:dai_phuoc_fe/models/apiresponse.dart';
import 'package:dai_phuoc_fe/models/userModels/useresponse.dart';
import 'package:dai_phuoc_fe/utils/app_config.dart';
import 'package:dai_phuoc_fe/utils/status_code.dart';
import 'package:http/http.dart' as http;

class UserService 
{
  final AppConfig _config = AppConfig();
  static const String model = 'User';

  ApiResponse<UserResponse> _responseHelper(ApiResponse<UserResponse> dataResponse, http.Response response){
      if (response.statusCode == StatusCode.ok) 
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
      else if (response.statusCode == StatusCode.internalServerError)
      {
        throw Exception('Lỗi server: ${dataResponse.message}');
      }
      else
      {
        throw Exception('Lỗi không xác định ${dataResponse.message}');
      }
  }

  Future<ApiResponse<UserResponse>> getUserByIdAsync(int idUser, String token) async 
  {
    try {

      final Uri uri = Uri.parse('${_config.apiBaseUrl}/$model/GetUserInfo');
      final headers = await AppConfig.getHeaders(token: token);

      final response = await http.post(
        uri,
        body: jsonEncode(idUser),
        headers: headers
      );

      Map<String, dynamic> jsonMap = jsonDecode(response.body);
      final ApiResponse<UserResponse> jsonResponse = ApiResponse.fromJson(
        jsonMap,
        (data){
          return UserResponse.fromJson(data);
        }
      );
      return _responseHelper(jsonResponse, response);
    } catch (e) 
    {
      // throw Exception('Lỗi khi gọi API $e');
      return ApiResponse(success: false, apiversion: "V1", message: 'Lỗi khi gọi API $e');
    }
  }
}