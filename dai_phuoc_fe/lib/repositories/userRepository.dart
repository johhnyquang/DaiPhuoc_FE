import 'dart:convert';

import 'package:dai_phuoc_fe/data/db_helper.dart';
import 'package:dai_phuoc_fe/models/userModels/useresponse.dart';
import 'package:dai_phuoc_fe/services/userService.dart';

class UserRepository {
  // Lấy dữ liệu từ API trả về cache thông tin user vào trong database riêng của máy
  final UserService _userService;
  final _dbHelper = DatabaseHelper();
  static const String tableName = 'daiphuoc_users';

  UserRepository({
    required UserService userService
  }): _userService = userService;

  // insert dữ liệu vào trong db nếu không có nếu có thì lấy ra
  Future<UserResponse?> insertOrGetUser(int userid, String token) async{
    try {
      // check dữ liệu trong db sqlite trước
      UserResponse? response = await _getUserById(userid);

      if (response != null) {
        return response;
      }

      //gọi đến API để query dữ liệu về
      final apiReponse = await _userService.getUserByIdAsync(userid, token);
      // insert vào trong sqlite
      await _insertUser(apiReponse.value!);
      return apiReponse.value!;

    } catch (e) {
      return UserResponse(
        id: 0, 
        hoTen: "", 
        soCMND: "", 
        sdt: "", 
        phai: "", 
        danToc: "", 
        quocTich: "", 
        tinhThanh: "", 
        phuongXa: ""
      );
    }
  }

  Future<int> _insertUser (UserResponse user) async{
    try {
      final db = await _dbHelper.db;
      return await db.insert(tableName, user.toJson());
    } catch (e) {
      throw Exception('Lỗi khi lưu vào SQLite $e');
    }
  }

  Future<UserResponse?> _getUserById (int id) async{
    final db = await _dbHelper.db;
    final result = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id]
    );

    if (result.isNotEmpty) {
      return UserResponse.fromJson(result.first);
    }
    return null;
  }
}