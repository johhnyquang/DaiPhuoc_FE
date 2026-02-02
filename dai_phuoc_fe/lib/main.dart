import 'package:dai_phuoc_fe/repositories/masterRepository.dart';
import 'package:dai_phuoc_fe/repositories/userRepository.dart';
import 'package:dai_phuoc_fe/services/authService.dart';
import 'package:dai_phuoc_fe/services/masterService.dart';
import 'package:dai_phuoc_fe/services/userService.dart';
import 'package:dai_phuoc_fe/viewmodels/authViewModel.dart';
import 'package:dai_phuoc_fe/views/screens/home_screen.dart';
import 'package:dai_phuoc_fe/views/screens/login_screen.dart';
import 'package:dai_phuoc_fe/views/screens/register_screen.dart';
import 'package:dai_phuoc_fe/views/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    // Set status bar màu trắng
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark, // Icons đen trên nền trắng
      statusBarBrightness: Brightness.light,
    ),
  );

  await dotenv.load(fileName: '.env');
    // Remove splash screen native sau khi init xong
  FlutterNativeSplash.remove();

  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // DI Service
        Provider(create: (_) => AuthService()),
        Provider(create: (_) => MasterService()),

        // DI Repo 
        // Vì tầng Repo đang có sự phụ thuộc vào tầng service nên sử dụng ProxyProvider
        ProxyProvider<MasterService, MasterRepository>(
          update: (context, value, previous) => MasterRepository(masterService: value)
        ),
        ProxyProvider<UserService, UserRepository>(
          update: (context, value, previous) => UserRepository(userService: value),
        ),

        // DI ViewModel
        ChangeNotifierProxyProvider<AuthService, AuthViewModel>(
          create: (context) => AuthViewModel(authService: context.read<AuthService>()),
          update: (context, value, previous) {
            return previous ?? AuthViewModel(authService: value);
          },
        )
      ],
      child: MaterialApp(
        title: 'Đại Phước Clinic',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true
        ),
        initialRoute: '/splash',
        routes: {
          '/splash': (_) => const SplashScreen(),
          '/register': (_) => const RegisterScreen(),
          '/login': (_) => const LoginScreen(),
          '/home':(_) => const HomeScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}