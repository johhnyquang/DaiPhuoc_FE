import 'package:dai_phuoc_fe/models/userModels/useresponse.dart';
import 'package:dai_phuoc_fe/repositories/userRepository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class HomeMenuItem {
  final String title;
  final IconData icon;
  final String route;
  final Color color;

  HomeMenuItem(
    this.title,
    this.icon,
    this.route,
    this.color
  );
}

class HomeViewModel extends ChangeNotifier {
  // get dữ liệu từ sqlite ra 
  final UserRepository _userRepository;
  UserResponse? _currentUser;
  bool _isLoading = true;

  HomeViewModel({
    required UserRepository userRepository
  }): _userRepository = userRepository {
    _loadUserInfo();
  }

  String get fullName => _currentUser?.hoTen ?? 'Người dùng';
  bool get isLoading => _isLoading;

  // Danh sách chức năng hiển thị ở Grid
  final List<HomeMenuItem> menuItems = [
    HomeMenuItem("Đặt lịch", Icons.calendar_month_rounded, '/booking', Colors.blue),
    //HomeMenuItem("Hồ sơ", Icons.folder_shared_rounded, '/records', Colors.orange),
    HomeMenuItem("Kết quả", Icons.analytics_rounded, '/results', Colors.green),
    HomeMenuItem("Toa thuốc", Icons.medication_rounded, '/prescriptions', Colors.teal),
    HomeMenuItem("Thanh toán", Icons.payment_rounded, '/payments', Colors.purple),
    HomeMenuItem("CSKH", Icons.support_agent_rounded, '/support', Colors.redAccent),
  ];

  Future<void> _loadUserInfo() async {
    _isLoading = true;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    int userid = prefs.getInt('UserId') ?? 0;
    String token = prefs.getString('AccessToken') ?? "";

    if (userid != 0) {
      _currentUser = await _userRepository.insertOrGetUser(userid, token);
    }
    
    _isLoading = false;
    notifyListeners();
  }
}