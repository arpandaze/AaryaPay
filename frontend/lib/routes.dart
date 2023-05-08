import 'package:aaryapay/screens/Login/login_screen.dart';
import 'package:aaryapay/screens/Login/forgot_password.dart';
import 'package:aaryapay/screens/Login/reset_password.dart';
import 'package:aaryapay/screens/Login/welcome_screen.dart';
import 'package:aaryapay/screens/QrScan/qrscan_screen.dart';
import 'package:aaryapay/screens/Register/register_screen.dart';
import 'package:aaryapay/screens/Send/send_money.dart';
import 'package:aaryapay/screens/Settings/AccountInformation/account_information.dart';
import 'package:aaryapay/screens/Settings/Favourites/favourites_screen.dart';
import 'package:aaryapay/screens/Settings/Password/change_password.dart';
import 'package:aaryapay/screens/Settings/Password/password_screen.dart';
import 'package:aaryapay/screens/Settings/Password/two_factor_auth_first.dart';
import 'package:aaryapay/screens/Settings/Password/two_factor_auth_second.dart';
import 'package:aaryapay/screens/Settings/Password/two_factor_auth_third.dart';
import 'package:aaryapay/screens/Settings/Syncronization/syncronization_screen.dart';
import 'package:aaryapay/screens/main_app_wrapper.dart';

final routes = {
  '/welcome': (context) => const WelcomeScreen(),
  '/login': (context) => const LoginScreen(),
  '/register': (context) => const RegisterScreen(),
  '/reset': (context) => const ResetPassword(),
  '/forgot_password': (context) => const ForgotPassword(),
  '/app': (context) => const MainAppWrapper(),
  '/app/qrscan': (context) => const QrScanScreen(),
  '/app/send': (context) => const SendMoney(),
  '/app/settings/account': (context) => const AccountInformation(),
  '/app/settings/password': (context) => const PasswordScreen(),
  '/app/settings/password/change': (context) => const ChangePassword(),
  '/app/settings/password/twofa/first': (context) => const TwoFactorAuthFirst(),
  '/app/settings/password/twofa/second': (context) =>
      const TwoFactorAuthSecond(),
  '/app/settings/password/twofa/third': (context) => const TwoFactorAuthThird(),
  '/app/settings/favorites': (context) => const FavouritesScreen(),
  '/app/settings/sync': (context) => const SyncronizationScreen(),
};
