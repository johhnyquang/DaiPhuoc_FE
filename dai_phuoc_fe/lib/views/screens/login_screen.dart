import 'package:dai_phuoc_fe/models/authModels/loginrequest.dart';
import 'package:dai_phuoc_fe/services/authService.dart';
import 'package:dai_phuoc_fe/viewmodels/authViewModel.dart';
import 'package:dai_phuoc_fe/views/widgets/common/custom_button.dart';
import 'package:dai_phuoc_fe/views/widgets/common/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}
class _LoginScreenState extends State<LoginScreen>{
  final _fromKey = GlobalKey<FormState>();
  final _cccdController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _cccdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build (BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng nhập'),
        elevation: 1,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            child: Form(
              key: _fromKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // LOGO 
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/thumbnail.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Đại Phước Clinic',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Nâng niu sức khỏe - Giữ trọn niềm tin',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.greenAccent
                    ),
                  ),
                  const SizedBox(height: 48),

                  // input field
                  CustomTextField(
                    label: 'Căn cước công dân *',
                    controller: _cccdController,
                    prefixIcon: Icons.account_box_rounded,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập căn cước công dân';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // --- OPTIMIZATION: Chỉ rebuild Password Field khi visibility thay đổi ---
                  Selector<AuthViewModel, bool>(
                    selector: (_, vm) => vm.isPasswordVisible,
                    builder: (context, isPasswordVisible, child) {
                      return CustomTextField(
                        label: 'Mật khẩu *',
                        hint: 'Ít nhất 8 ký tự',
                        controller: _passwordController,
                        prefixIcon: Icons.lock,
                        obscureText: !isPasswordVisible,
                        suffix: IconButton(
                          onPressed: () => context.read<AuthViewModel>().togglePasswordVisibility(),
                          icon: Icon(isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                        ),
                        validator: (value){
                          if (value == null || value.isEmpty) return 'Vui lòng nhập mật khẩu';
                          if (value.length < 8) return 'Mật khẩu phải có ít nhất 8 ký tự'; 
                          if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) return 'Phải chứa chữ hoa, chữ thường và số';
                          return null;
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 24),
                  // --- ERROR MESSAGE: Chỉ hiển thị khi có lỗi ---
                  Selector<AuthViewModel, String?>(
                    selector: (_, vm) => vm.errorMessage,
                    builder: (_, errorMessage, __) {
                      if (errorMessage == null) return const SizedBox.shrink();
                      return Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200)
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error, color: Colors.red.shade700, size: 20),
                            const SizedBox(height: 8),
                            Expanded(
                              child: Text(
                                errorMessage,
                                style: TextStyle(color: Colors.red.shade700, fontSize: 14),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                  ),

                  Selector<AuthViewModel, bool>(
                    selector: (_, vm) => vm.isLoading,
                    builder: (context, value, _) {
                      return Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              label: 'Đăng nhập',
                              onPressed: () => _handleLogin(context),
                              isLoading: value,
                              icon: Icons.login_sharp,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomButton(
                              label: 'Đăng ký',
                              onPressed: value 
                                ? null : 
                                () => Navigator.pushReplacementNamed(context, '/register'),
                              icon: Icons.app_registration_rounded,
                            ),
                          )
                        ],
                      );
                    },
                  )
                ],
              ),
            ),
          ),  
        ),
      ),
    );
  }
  
  /*Widget build(BuildContext context) {
    // final loginViewModel = Provider.of<AuthViewModel>(context);
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(
        authService: context.read<AuthService>()
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Đăng nhập'),
          elevation: 1,
        ),

        // Sử dụng Builder để có context chứa AuthViewModel vừa tạo
        body: Builder(
          builder: (context) {
            // Lấy reference đến ViewModel nhưng không lắng nghe thay đổi 
            final viewModel = context.read<AuthViewModel>();

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _fromKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo and App Name
                      const SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/thumbnail.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Đại Phước Clinic',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Nâng niu sức khỏe - Giữ trọn niềm tin',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.greenAccent
                        ),
                      ),
                      const SizedBox(height: 48),

                      // input field
                      CustomTextField(
                        label: 'Căn cước công dân *',
                        controller: _cccdController,
                        prefixIcon: Icons.account_box_rounded,
                        keyboardType: TextInputType.number,
                        enabled: !viewModel.isLoading,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập căn cước công dân';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // --- OPTIMIZATION: Chỉ rebuild Password Field khi visibility thay đổi ---
                      Selector<AuthViewModel, bool>(
                        selector: (_, vm) => vm.isPasswordVisible,
                        builder: (context, isPasswordVisible, child) {
                          return CustomTextField(
                            label: 'Mật khẩu *',
                            hint: 'Ít nhất 8 ký tự',
                            controller: _passwordController,
                            prefixIcon: Icons.lock,
                            obscureText: !isPasswordVisible,
                            suffix: IconButton(
                              onPressed: () => context.read<AuthViewModel>().togglePasswordVisibility(),
                              icon: Icon(isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                            ),
                            validator: (value){
                              if (value == null || value.isEmpty) return 'Vui lòng nhập mật khẩu';
                              if (value.length < 8) return 'Mật khẩu phải có ít nhất 8 ký tự'; 
                              if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) return 'Phải chứa chữ hoa, chữ thường và số';
                              return null;
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // --- ERROR MESSAGE: Chỉ hiển thị khi có lỗi ---
                      Selector<AuthViewModel, String?>(
                        selector: (_, vm) => vm.errorMessage,
                        builder: (_, errorMessage, __) {
                          if (errorMessage == null) return const SizedBox.shrink();
                          return Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade200)
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.error, color: Colors.red.shade700, size: 20),
                                const SizedBox(height: 8),
                                Expanded(
                                  child: Text(
                                    errorMessage,
                                    style: TextStyle(color: Colors.red.shade700, fontSize: 14),
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                      ),

                      Selector<AuthViewModel, bool>(
                        selector: (_, vm) => vm.isLoading,
                        builder: (context, value, child) {
                          return Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomButton(
                                    label: 'Đăng nhập',
                                    onPressed: () => _handleLogin(context, viewModel),
                                    isLoading: viewModel.isLoading,
                                    icon: Icons.login_sharp,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: CustomButton(
                                    label: 'Đăng ký',
                                    onPressed: () => Navigator.pushReplacementNamed(context, '/register'),
                                    isLoading: viewModel.isLoading,
                                    icon: Icons.app_registration_rounded,
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      )

                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }*/
  
  Future<void> _handleLogin(BuildContext context) async {
    if (!_fromKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();
    LoginRequest loginRequest = LoginRequest(cccd: _cccdController.text.trim(), password: _passwordController.text.trim());
    final response = await context.read<AuthViewModel>().login(loginRequest: loginRequest);
    if (response != null && context.mounted) {
      // show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          icon: const Icon(Icons.check_circle, color: Colors.green,size: 60),
          title: const Text('Đăng nhập thành công'),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context); // close dialog
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: const Text('OK'),
            )
          ],
        ),
      );
    }
  }

}