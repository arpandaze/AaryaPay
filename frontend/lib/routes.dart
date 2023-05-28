import 'package:aaryapay/screens/Login/login_screen.dart';
import 'package:aaryapay/screens/Login/forgot_password.dart';
import 'package:aaryapay/screens/Login/reset_password.dart';
import 'package:aaryapay/screens/Login/welcome_screen.dart';
import 'package:aaryapay/screens/QrScan/qrscan_screen.dart';
import 'package:aaryapay/screens/Register/register_screen.dart';
import 'package:aaryapay/screens/SplashScreen/splash_screen.dart';
import 'package:aaryapay/screens/main_app_wrapper.dart';
import 'package:aaryapay/screens/Entrypoint/entrypoint.dart';

final routes = {
  '/welcome': (context) => const WelcomeScreen(),
  '/login': (context) => const LoginScreen(),
  '/register': (context) => const RegisterScreen(),
  '/reset': (context) => const ResetPassword(),
  '/forgot_password': (context) => const ForgotPassword(),
  '/app': (context) => const MainAppWrapper(),
  '/app/qrscan': (context) => const QrScanScreen(),
  '/splash': (context) => const SplashScreen(),
};
