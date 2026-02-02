import 'package:dai_phuoc_fe/models/apiresponse.dart';
import 'package:dai_phuoc_fe/models/authModels/loginrequest.dart';
import 'package:dai_phuoc_fe/models/authModels/loginresponse.dart';
import 'package:dai_phuoc_fe/models/authModels/register.dart';
import 'package:dai_phuoc_fe/models/authModels/rotationmodel.dart';
import 'package:dai_phuoc_fe/models/masterModels/dantocmodels.dart';
import 'package:dai_phuoc_fe/models/masterModels/phuongxamodels.dart';
import 'package:dai_phuoc_fe/models/masterModels/quocgiamodels.dart';
import 'package:dai_phuoc_fe/models/masterModels/tinhthanhmodels.dart';
import 'package:dai_phuoc_fe/models/validationModel.dart';
import 'package:dai_phuoc_fe/repositories/masterRepository.dart';
import 'package:dai_phuoc_fe/repositories/userRepository.dart';
import 'package:dai_phuoc_fe/services/authService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService; 
  UserRepository? _userRepository;
  MasterRepository? _masterRepository;

  AuthViewModel({
    required AuthService authService,
    UserRepository? userRepository,
    MasterRepository? masterRepository
  }): _authService= authService, _userRepository = userRepository, _masterRepository = masterRepository;

  // state
  bool _isLoading = false;
  String? _errorMessage;
  bool _isTokenResponsed = false;

  // Password visibility
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Caching variable
  List<PhuongXaModel>? _cachedPhuongXa;
  List<TinhThanhModel>? _cachedTinhThanh;
  List<DanTocModel>? _cachedDanToc;
  List<QuocGiaModel>? _cachedQuocGia;

  // getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null ? true : false;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;

  // toggle password visibility
  void togglePasswordVisibility(){
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility(){
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  Future<List<TinhThanhModel>?> getAllTinhThanh()async{
    if (_cachedTinhThanh != null && _cachedTinhThanh!.isNotEmpty) {
      return _cachedTinhThanh;
    }

    try {
      final response = await _masterRepository?.getAllTinhThanh();
      _cachedTinhThanh = response; // lưu vào cache
      return response;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    }
  }
  
  Future<List<PhuongXaModel>?> getAllPhuongXa() async {
    if (_cachedPhuongXa != null && _cachedPhuongXa!.isNotEmpty) {
      return _cachedPhuongXa;
    }

    try {
      final response = await _masterRepository?.getAllPhuongXa();
      _cachedPhuongXa = response;
      return response;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    }
  }

  Future<List<QuocGiaModel>?> getAllQuocGia() async {
    if (_cachedQuocGia != null && _cachedQuocGia!.isNotEmpty) {
      return _cachedQuocGia;
    }

    try {
      final response = await _masterRepository?.getAllQuocGia();
      _cachedQuocGia = response;
      return response;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    }
  }

  Future<List<DanTocModel>?> getAllDanToc() async {
    if (_cachedDanToc != null && _cachedDanToc!.isNotEmpty) {
      return _cachedDanToc;
    }

    try {
      final response = await _masterRepository?.getAllDanToc();
      _cachedDanToc = response;
      return response;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    }
  }

  Future<ApiResponse<LoginResponse>> refreshToken({
    required String? accessToken,
    required String? refreshToken
  })async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final rotation = RotationModel(accessToken: accessToken!, refreshToken: refreshToken!);
      final response = await _authService.refreshToken(rotation);
      if (response.success == false) {
        return response;
      }
      // lưu vào share prefs
      await _saveInfoResponse(response.value);
      // sau khi lưu thông tin user vào trong prefs thì gọi đến userRepo để check user có tồn tại trong sqlite
      await _userRepository?.insertOrGetUser(response.value!.id);

      return response;

    } catch (e) {
      _errorMessage = e.toString();
      return ApiResponse(success: false, apiversion: 'V1', message: _errorMessage!);
    }
    finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<ApiResponse<LoginResponse>?> login({
    required LoginRequest loginRequest,
    ApiResponse<LoginResponse>? loginResponse
  })async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {

      // Validate input
      ValidationModel validate = _validationField(loginRequest, null);
      if (validate.status == false) {
        _errorMessage = validate.message;
        return ApiResponse(success: validate.status, apiversion: 'V1', message: _errorMessage!);
      }

      var response = loginResponse;

      if (_isTokenResponsed == false) {
        
        response = await _authService.loginAsync(loginRequest);

        if (response.success == false) {
           _errorMessage = validate.message;
          return ApiResponse(success: response.success, apiversion: response.apiversion, message: _errorMessage!);
        }
      }

      // Xóa data cũ trước khi thêm
      await _clearInfoUser();

      // Thêm thông tin mới vào
      await _saveInfoResponse(response!.value);
      // sau khi lưu thông tin user vào trong prefs thì gọi đến userRepo để check user có tồn tại trong sqlite
      await _userRepository?.insertOrGetUser(response.value!.id);

      notifyListeners();
      return response;

    } catch (e) {
      _errorMessage = e.toString();
      return ApiResponse(success: false, apiversion: 'V1', message: _errorMessage!);
    }
    finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<ApiResponse<LoginResponse>?> register({
    required String cccd,
    required String hoten,
    required String password,
    required String sdt,
    required DateTime ngaysinh,
    required String quoctich,
    required String dantoc,
    required String tinhthanh,
    required String phuongxa,
    required bool phai,
    String? email,
    String? ipAddress,
    String? deviceId
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // create register model
      Register register = Register(cccd: cccd, hoten: hoten, sdt: sdt, password: password, phai: phai, quoctich: quoctich, dantoc: dantoc, tinhthanh: tinhthanh, phuongxa: phuongxa, ngaysinh: ngaysinh);

      // Validate
      ValidationModel validationModel = _validationField(null, register);
      if (validationModel.status == false) {
        //return ValidationModel(status: validationModel.status, message: validationModel.message);
        _errorMessage = validationModel.message;
        return ApiResponse(success: validationModel.status, apiversion: "V1", message: _errorMessage!);
      }

      final result = await _authService.registerAsync(register);

      if (result.success == false) {
        _errorMessage = result.message;
        return ApiResponse(success: validationModel.status, apiversion: "v1", message: _errorMessage!);
      }

      if (result.success == true) {
        _isTokenResponsed = true;
      }

      LoginRequest loginRequest = LoginRequest(cccd: cccd, password: password);

      return await login(loginRequest: loginRequest, loginResponse: result);
    } catch (e) {
      _errorMessage = e.toString();
        return ApiResponse(success: false, apiversion: "v1", message: _errorMessage!);
    }
    finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError (){
    _errorMessage = null;
    notifyListeners();
  }

  // save token in share prefs
  Future<void> _saveInfoResponse(LoginResponse? loginResponse) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('AccessToken', loginResponse?.accessToken ?? '');
    await prefs.setString('RefreshToken', loginResponse?.refreshToken ?? '');
    // await prefs.setString('RefreshTokenExpiryTime', loginResponse?.refreshTokenExpiryTime.toIso8601String() ?? DateTime.now().toIso8601String());
    await prefs.setInt('UserId', loginResponse?.id ?? 0);
    await prefs.setString('UserRole', loginResponse?.role ?? '');
    await prefs.setBool('isLogin', true);
  }
  
  Future<void> _clearInfoUser() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('AccessToken');
    await prefs.remove('RefreshToken');
    // await prefs.remove('RefreshTokenExpiryTime');
    await prefs.remove('UserId');
    await prefs.remove('UserRole');
    await prefs.remove('isLogin');
  }

  Future<void> _clearAllInApp() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Validation 
  ValidationModel _validationField(LoginRequest? loginRequest, Register? register) {
    if (loginRequest != null) {
      if (loginRequest.cccd.isEmpty) {
        return ValidationModel(status: false, message: 'CCCD không được để trống');
      }
      if (loginRequest.password.isEmpty) {
        return ValidationModel(status: false, message: 'Password không được để trống');
      }
    }
    else{

      if (register!.cccd.isEmpty) {
        return ValidationModel(status: false, message: 'CCCD không được để trống');
      }
      if (register.hoten.isEmpty) {
        return ValidationModel(status: false, message: 'Họ tên không được để trống');
      }
      if (register.sdt.isEmpty) {
        return ValidationModel(status: false, message: 'Số điện thoại không được để trống');
      }
      if (register.password.isEmpty) {
        return ValidationModel(status: false, message: 'Mật khẩu không được để trống');
      }
      if (register.ngaysinh == null) {
        return ValidationModel(status: false, message: 'Ngày sinh không được để trống');
      }
      if (register.quoctich.isEmpty) {
        return ValidationModel(status: false, message: 'Quốc tịch không được để trống');
      }
      if (register.dantoc.isEmpty) {
        return ValidationModel(status: false, message: 'Dân tộc không được để trống');
      }
      if (register.tinhthanh.isEmpty) {
        return ValidationModel(status: false, message: 'Tỉnh thành không được để trống');
      }
      if (register.phuongxa.isEmpty) {
        return ValidationModel(status: false, message: 'Phường xã không được để trống');
      }
    }
    return ValidationModel(status: true, message: 'Thỏa mãn điều kiện');
  }
}