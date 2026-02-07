import 'dart:convert';

import 'package:dai_phuoc_fe/models/apiresponse.dart';
import 'package:dai_phuoc_fe/models/masterModels/dantocmodels.dart';
import 'package:dai_phuoc_fe/models/masterModels/phuongxamodels.dart';
import 'package:dai_phuoc_fe/models/masterModels/quocgiamodels.dart';
import 'package:dai_phuoc_fe/models/masterModels/tinhthanhmodels.dart';
import 'package:dai_phuoc_fe/utils/app_config.dart';
import 'package:dai_phuoc_fe/utils/status_code.dart';
import 'package:http/http.dart' as http;

class MasterService<T> {
  final AppConfig _config = AppConfig();

  // ignore: avoid_shadowing_type_parameters
  ApiResponse<T> _responseHelper<T>(ApiResponse<T> dataResponse,  http.Response response){
    if (response.statusCode == StatusCode.ok) {
      if (dataResponse.success == true && dataResponse.value != null) {
        return dataResponse;
      }
      else{
        throw Exception(dataResponse.message);
      }
    }else if (response.statusCode == StatusCode.internalServerError){
      throw Exception('Lỗi server: ${dataResponse.message}');
    }
    else{
      throw Exception('Lỗi không xác định ${dataResponse.message}');
    }
  }

  Future<ApiResponse<List<TinhThanhModel>>> getTinhThanhAsync(String model)async{
    try {
      final Uri uri = Uri.parse('${_config.apiBaseUrl}/$model');
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        }
      );

    Map<String, dynamic> jsonMap = jsonDecode(response.body);
    
    ApiResponse<List<TinhThanhModel>> jsonResponse = ApiResponse.fromJson(
      jsonMap,
      (data) {
        if (data is List) {
          return data.map((item) => TinhThanhModel.fromJson(item)).toList();
        }
        return <TinhThanhModel>[];
      }
    );

      return _responseHelper<List<TinhThanhModel>>(jsonResponse, response);
    } catch (e) {
          throw Exception('Lỗi khi gọi API: $e');
    }
  }

  Future<ApiResponse<List<PhuongXaModel>>> getPhuongXaAsync(String model)async{
    try {
      final Uri uri = Uri.parse('${_config.apiBaseUrl}/$model');
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        }
      );

    Map<String, dynamic> jsonMap = jsonDecode(response.body);
    
    ApiResponse<List<PhuongXaModel>> jsonResponse = ApiResponse.fromJson(
      jsonMap,
      (data) {
        if (data is List) {
          return data.map((item) => PhuongXaModel.fromJson(item)).toList();
        }
        return <PhuongXaModel>[];
      }
    );

      return _responseHelper<List<PhuongXaModel>>(jsonResponse, response);
    } catch (e) {
          throw Exception('Lỗi khi gọi API: $e');
    }
  }

  Future<ApiResponse<List<QuocGiaModel>>> getQuocGiaAsync(String model)async{
    try {
      final Uri uri = Uri.parse('${_config.apiBaseUrl}/$model');
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        }
      );

    Map<String, dynamic> jsonMap = jsonDecode(response.body);
    
    ApiResponse<List<QuocGiaModel>> jsonResponse = ApiResponse.fromJson(
      jsonMap,
      (data) {
        if (data is List) {
          return data.map((item) => QuocGiaModel.fromJson(item)).toList();
        }
        return <QuocGiaModel>[];
      }
    );

      return _responseHelper<List<QuocGiaModel>>(jsonResponse, response);
    } catch (e) {
          throw Exception('Lỗi khi gọi API: $e');
    }
  }

  Future<ApiResponse<List<DanTocModel>>> getDanTocAsync(String model)async{
    try {
      final Uri uri = Uri.parse('${_config.apiBaseUrl}/$model');
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        }
      );

    Map<String, dynamic> jsonMap = jsonDecode(response.body);
    
    ApiResponse<List<DanTocModel>> jsonResponse = ApiResponse.fromJson(
      jsonMap,
      (data) {
        if (data is List) {
          return data.map((item) => DanTocModel.fromJson(item)).toList();
        }
        return <DanTocModel>[];
      }
    );

      return _responseHelper<List<DanTocModel>>(jsonResponse, response);
    } catch (e) {
          throw Exception('Lỗi khi gọi API: $e');
    }
  }
}