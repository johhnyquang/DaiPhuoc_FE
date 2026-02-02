import 'package:dai_phuoc_fe/models/masterModels/dantocmodels.dart';
import 'package:dai_phuoc_fe/models/masterModels/phuongxamodels.dart';
import 'package:dai_phuoc_fe/models/masterModels/quocgiamodels.dart';
import 'package:dai_phuoc_fe/models/masterModels/tinhthanhmodels.dart';
import 'package:dai_phuoc_fe/repositories/masterRepository.dart';
import 'package:dai_phuoc_fe/services/authService.dart';
import 'package:dai_phuoc_fe/utils/dropdown_constant.dart';
import 'package:dai_phuoc_fe/viewmodels/authViewModel.dart';
import 'package:dai_phuoc_fe/views/widgets/common/api_dropdown.dart';
import 'package:dai_phuoc_fe/views/widgets/common/custom_button.dart';
import 'package:dai_phuoc_fe/views/widgets/common/custom_dropdown.dart';
import 'package:dai_phuoc_fe/views/widgets/common/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fromKey = GlobalKey<FormState>();
  final _cccdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _sdtController = TextEditingController();
  final _hotenController = TextEditingController();
  final _emailController = TextEditingController(); 
  DateTime? _ngaysinh;
  bool _phai = false;

  TinhThanhModel? _selectedTinhThanh;
  PhuongXaModel? _selectedPhuongXa;
  DanTocModel? _selectedDanToc;
  QuocGiaModel? _selectedQuocGia;

  @override
  void dispose() {
    _cccdController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _sdtController.dispose();
    _hotenController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Khởi tạo Provider nhưng KHÔNG dùng Consumer bao trùm tất cả
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(
        authService: context.read<AuthService>(),
        masterRepository: context.read<MasterRepository>()
      ),
      child: Scaffold(
         appBar: AppBar(
          title: const Text('Đăng Ký Tài Khoản'),
          elevation: 0,
        ),
        // Sử dụng Builder để có context chứa AuthViewModel vừa tạo
        body: Builder(
          builder: (context) {
            // Lấy reference đến viewModel nhưng không lắng nghe thay đổi (listen: false)
            // Dùng để gọi hàm fetchItems trong Dropdown
            final viewModel = context.read<AuthViewModel>();

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _fromKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Các TextField này không cần rebuild khi ViewModel thay đổi
                      CustomTextField(
                        label: 'Họ và tên *',
                        hint: 'Nhập họ tên đầy đủ',
                        controller: _hotenController,
                        prefixIcon: Icons.person,
                        // enabled: !viewModel.isLoading, -> Tạm bỏ check loading realtime ở đây để tối ưu performance
                        validator: (value){
                          if (value == null || value.trim().isEmpty) return 'Vui lòng nhập họ tên';
                          if (value.trim().length < 2) return 'Họ tên có ít nhất 2 ký tự';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Căn cước công dân *',
                        controller: _cccdController,
                        prefixIcon: Icons.account_box_rounded,
                        keyboardType: TextInputType.number,
                        validator: (value) => (value == null || value.isEmpty) ? 'Vui lòng nhập số căn cước công dân' : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Số điện thoại *',
                        hint: '113',
                        controller: _sdtController,
                        prefixIcon: Icons.phone_android_outlined,
                        keyboardType: TextInputType.phone,
                        validator: (value){
                          if (value == null) return 'Vui lòng nhập số điện thoại';
                          if (value.trim().length != 10) return 'Độ dài số điện thoại không hợp lệ';
                          if (!RegExp(r'^0[0-9]{9}$').hasMatch(value)) return 'Số điện thoại không hợp lệ';
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
                      
                      const SizedBox(height: 16),
                      
                      // --- OPTIMIZATION: Chỉ rebuild Confirm Password Field ---
                      Selector<AuthViewModel, bool>(
                        selector: (_, vm) => vm.isConfirmPasswordVisible,
                        builder: (context, isConfirmVisible, child) {
                          return CustomTextField(
                            label: 'Xác nhận lại mật khẩu *',
                            hint: 'Nhập lại mật khẩu',
                            controller: _confirmPasswordController,
                            prefixIcon: Icons.lock_outline,
                            obscureText: !isConfirmVisible,
                            suffix: IconButton(
                              onPressed: () => context.read<AuthViewModel>().toggleConfirmPasswordVisibility(),
                              icon: Icon(isConfirmVisible ? Icons.visibility_off : Icons.visibility),
                            ),
                            validator: (value){
                              if (value != _passwordController.text) return 'Mật khẩu xác nhận không khớp';
                              return null;
                            },
                          );
                        }
                      ),

                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _BirthDatePicker(
                              selectedDate: _ngaysinh,
                              onDateSelected: (value) => setState(() { _ngaysinh = value; }),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomDropdown<bool>(
                              label: 'Giới tính',
                              hint: 'Chọn giới tính',
                              value: _phai,
                              prefixIcon: Icons.person,
                              isRequired: true,
                              items: DropdownConstant.genders,
                              onChanged: (value) => setState(() { _phai = value!; }),
                              validator: (value) => value == null ? 'Vui lòng chọn giới tính' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // --- DROPDOWNS: Nằm ngoài Selector nên KHÔNG bị rebuild khi gõ phím ---
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ApiDropdown<TinhThanhModel>(
                            label: 'Tỉnh thành',
                            hint: 'Chọn tỉnh thành',
                            value: _selectedTinhThanh,
                            fetchItems: () async {
                              // Nhờ cơ chế cache trong ViewModel, hàm này sẽ trả về rất nhanh ở các lần sau
                              List<TinhThanhModel>? response = await viewModel.getAllTinhThanh();
                              return response ?? [];
                            },
                            itemLabel: (tinhthanh) => tinhthanh.tentinhthanh,
                            onChanged: (value) => setState(() { _selectedTinhThanh = value; }),
                          ),
                          const SizedBox(height: 16),
                          ApiDropdown<PhuongXaModel>(
                            label: 'Phường xã',
                            hint: 'Chọn phường xã',
                            value: _selectedPhuongXa,
                            fetchItems: ()async {
                              List<PhuongXaModel>? response = await viewModel.getAllPhuongXa();
                              return response ?? [];
                            },
                            itemLabel: (phuongxa) => '${phuongxa.tenphuongxa} ',
                            onChanged: (value) => setState(() { _selectedPhuongXa = value; }),
                          ),
                          const SizedBox(height: 16),
                          ApiDropdown<DanTocModel>(
                            label: 'Dân tộc',
                            hint: 'Chọn dân tộc',
                            value: _selectedDanToc,
                            fetchItems: () async{
                              List<DanTocModel>? response = await viewModel.getAllDanToc();
                              return response ?? [];
                            },
                            itemLabel: (dantoc) => '${dantoc.tendantoc} ',
                            onChanged: (value) => setState(() { _selectedDanToc = value; }),
                          ),
                          const SizedBox(height: 16),
                          Flexible(
                            fit: FlexFit.loose,
                            child: ApiDropdown<QuocGiaModel>(
                              label: 'Quốc gia',
                              hint: 'Chọn quốc gia',
                              value: _selectedQuocGia,
                              fetchItems: () async {
                                List<QuocGiaModel>? response = await viewModel.getAllQuocGia();
                                return response ?? [];
                              },
                              itemLabel: (quocgia) => '${quocgia.tenquocgia} ',
                              onChanged: (value) => setState(() { _selectedQuocGia = value; }),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      
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

                      // --- BUTTON: Chỉ rebuild trạng thái loading ---
                      Selector<AuthViewModel, bool>(
                        selector: (_, vm) => vm.isLoading,
                        builder: (context, isLoading, child) {
                          return CustomButton(
                            label: 'Đăng ký',
                            onPressed: () => _handleRegister(context, context.read<AuthViewModel>()),
                            isLoading: isLoading, 
                          );
                        }
                      ),

                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Đã có tài khoản', style: TextStyle(color: Colors.grey.shade700)),
                          // Check loading để disable nút login
                          Selector<AuthViewModel, bool>(
                            selector: (_, vm) => vm.isLoading,
                            builder: (context, isLoading, _) {
                              return TextButton(
                                onPressed: isLoading ? null : () => Navigator.pushReplacementNamed(context, '/login'),
                                child: const Text('Đăng nhập', style: TextStyle(fontWeight: FontWeight.bold)),
                              );
                            }
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }
  
  // Logic xử lý Register giữ nguyên, nhưng chú ý validate null safety cho dropdown
  Future<void> _handleRegister(BuildContext context, AuthViewModel viewModel) async {
    if (!_fromKey.currentState!.validate()) return;

    if (_ngaysinh == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng chọn ngày sinh')));
      return;
    }
    // Validate dropdowns (quan trọng vì user có thể chưa chọn)
    if (_selectedTinhThanh == null || _selectedPhuongXa == null || _selectedDanToc == null || _selectedQuocGia == null) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng chọn đầy đủ thông tin hành chính')));
       return;
    }

    FocusScope.of(context).unfocus();

    final response = await viewModel.register(
      cccd:  _cccdController.text.trim(),
      hoten: _hotenController.text.trim(),
      sdt: _sdtController.text.trim(),
      ngaysinh: _ngaysinh!,
      phai: _phai,
      password: _passwordController.text.trim(),
      dantoc: _selectedDanToc!.madantoc,
      quoctich: _selectedQuocGia!.maquocgia,
      phuongxa: _selectedPhuongXa!.maphuongxa,
      tinhthanh: _selectedTinhThanh!.matinhthanh
    );

    if (response != null && response.success && context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          icon: const Icon(Icons.check_circle, color: Colors.green,size: 60),
          title: const Text('Đăng ký thành công'),
          content: const Text('Tài khoản của bạn đã tạo thành công'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: const Text('OK'),
            )
          ],
        )
      );
    }
  }
}

// Widget _BirthDatePicker giữ nguyên
class _BirthDatePicker extends StatelessWidget{
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final bool enabled;

  const _BirthDatePicker({
    required this.selectedDate,
    required this.onDateSelected,
    this.enabled = true
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? () => _selectedDate(context): null,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Ngày sinh *',
          prefixIcon: const Icon(Icons.calendar_today),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabled: enabled
        ),
        child: Text(
          selectedDate != null ? DateFormat('dd/MM/yyyy').format(selectedDate!) : 'Chọn ngày sinh',
          style: TextStyle(color: selectedDate != null ? Colors.black : Colors.grey),
        ),
      ),
    );
  }

  Future<void> _selectedDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Chọn ngày sinh',
      cancelText: 'Hủy',
      confirmText: 'OK',
    );
    if (date != null) onDateSelected(date);
  }
}