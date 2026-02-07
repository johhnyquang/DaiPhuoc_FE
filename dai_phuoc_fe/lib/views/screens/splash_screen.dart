import 'dart:async'; // Cần import để dùng Future.wait
import 'package:dai_phuoc_fe/viewmodels/authViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    
    // Bắt đầu quy trình kiểm tra ngay khi init
    _startAppFlow(); 
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000), // Branding animation: 2 giây
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    
    _animationController.forward();
  }

  Future<void> _startAppFlow() async {
    // Kỹ thuật chạy song song:
    // Task 1: Chờ ít nhất 2 giây để chạy hết animation (branding).
    // Task 2: Kiểm tra logic đăng nhập (có thể nhanh hoặc chậm hơn 2s).
    
    final minSplashTime = Future.delayed(const Duration(seconds: 2));
    final checkLoginTask = _checkLoginStatus();

    // Future.wait sẽ đợi cả 2 task hoàn thành.
    // Nếu checkLoginTask xong trong 0.5s, nó vẫn đợi đủ 2s của minSplashTime.
    // Nếu checkLoginTask mất 5s, nó sẽ đợi hết 5s.
    final result = await Future.wait([
      minSplashTime,
      checkLoginTask, 
    ]);

    // Kết quả của checkLoginTask nằm ở index 1
    final bool isLoggedIn = result[1] as bool;

    if (!mounted) return;

    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  /// Hàm trả về true nếu token hợp lệ, false nếu cần login lại
  Future<bool> _checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('AccessToken');
      final refreshToken = prefs.getString('RefreshToken');

      // 1. Nếu không có token trong máy -> Bắt buộc login
      if (accessToken == null || refreshToken == null) {
        return false; 
      }

      // 2. Nếu có token -> Gọi API Refresh để validate
      // Lưu ý: Dùng context.read để tránh rebuild không cần thiết
      final viewModel = context.read<AuthViewModel>();
      
      // Giả sử hàm refreshToken trả về ApiResponse
      final response = await viewModel.refreshToken(
        accessToken: accessToken, 
        refreshToken: refreshToken
      );

      // Nếu API trả về success = true, nghĩa là token đã được làm mới và lưu lại
      return response.success;

    } catch (e) {
      // Có lỗi (mất mạng, server lỗi...) -> An toàn nhất là về trang Login
      debugPrint("Splash Error: $e");
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
      return false;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png', width: 150), // Nên set width/height cụ thể
                const SizedBox(height: 24),
                const Text(
                  'Đại Phước Clinic',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Quản lý sức khỏe thông minh',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 40),
                // Có thể bỏ Loading Indicator nếu animation logo đã đẹp
                // hoặc giữ lại để báo hiệu đang call API
                const SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}