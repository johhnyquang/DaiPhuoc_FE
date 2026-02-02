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

  Future<ApiResponse<UserResponse>> getUserByIdAsync(int idUser) async 
  {
    try {

      final Uri uri = Uri.parse('${_config.apiBaseUrl}/$model/GetUserInfo');

      final response = await http.post(
        uri,
        body: idUser,
        headers: {"Content-Type": "application/json"}
      );

      final ApiResponse<UserResponse> dataResponse = jsonDecode(response.body);
      return _responseHelper(dataResponse, response);
    } catch (e) 
    {
      throw Exception('Lỗi khi gọi API $e');
    }
  }
}