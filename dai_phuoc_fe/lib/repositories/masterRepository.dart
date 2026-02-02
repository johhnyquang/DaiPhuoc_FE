import 'package:dai_phuoc_fe/models/masterModels/dantocmodels.dart';
import 'package:dai_phuoc_fe/models/masterModels/phuongxamodels.dart';
import 'package:dai_phuoc_fe/models/masterModels/quocgiamodels.dart';
import 'package:dai_phuoc_fe/models/masterModels/tinhthanhmodels.dart';
import 'package:dai_phuoc_fe/services/masterService.dart';

class MasterRepository {
  final MasterService _masterService;

  MasterRepository({
    required MasterService masterService
  }) : _masterService = masterService;

  //Get dữ liệu master
  Future<List<TinhThanhModel>> getAllTinhThanh()async{
    try {
      // Gọi đến service để gọi API
      final apiResponse = await _masterService.getTinhThanhAsync('TinhThanh');
      return apiResponse.value!;
      
    } catch (e) {
      throw Exception('Lỗi không xác định $e');
    }
  }

  Future<List<PhuongXaModel>> getAllPhuongXa() async{
    try {
      // Gọi đến service để gọi API
      final apiResponse = await _masterService.getPhuongXaAsync('PhuongXa');
      return apiResponse.value!;
      
    } catch (e) {
      throw Exception('Lỗi không xác định $e');
    }
  }

  Future<List<QuocGiaModel>> getAllQuocGia() async{
    try {
      // Gọi đến service để gọi API
      final apiResponse = await _masterService.getQuocGiaAsync('QuocGia');
      return apiResponse.value!;
      
    } catch (e) {
      throw Exception('Lỗi không xác định $e');
    }
  }

  Future<List<DanTocModel>> getAllDanToc() async{
    try {
      // Gọi đến service để gọi API
      final apiResponse = await _masterService.getDanTocAsync('DanToc');
      return apiResponse.value!;
      
    } catch (e) {
      throw Exception('Lỗi không xác định $e');
    }
  }
}