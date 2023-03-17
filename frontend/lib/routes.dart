import 'package:aaryapay/screens/Home/home_screen.dart';
import 'package:aaryapay/screens/Login/login_screen.dart';
import 'package:aaryapay/screens/Login/forgot_password.dart';
import 'package:aaryapay/screens/Login/reset_password.dart';
import 'package:aaryapay/screens/Login/welcome_screen.dart';

final routes = {
  '/home': (context) => const HomeScreen(),
  '/login': (context) => const LoginScreen(),
  '/welcome': (context) => const WelcomeScreen(),
  '/reset': (context) => const ResetPassword(),
  '/forgot_password': (context) => const ForgotPassword()
};
