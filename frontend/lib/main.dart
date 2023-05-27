import 'package:aaryapay/components/SnackBarService.dart';
import 'package:aaryapay/global/authentication/authentication_bloc.dart';
import 'package:aaryapay/global/bloc/data_bloc.dart';
import 'package:aaryapay/helper/utils.dart';
import 'package:flutter/material.dart';
import 'package:aaryapay/routes.dart';
import 'package:aaryapay/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(),
        ),
        BlocProvider<DataBloc>(
          create: (context) => DataBloc(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: Utils.mainAppNav,
        scaffoldMessengerKey: SnackBarService.scaffoldKey,
        debugShowCheckedModeBanner: false,
        routes: routes,
        title: 'AaryaPay',
        initialRoute: '/welcome',
        color: const Color(0xfff4f6fa),
        theme: AppTheme.lightTheme,
      ),
    );
  }
}
