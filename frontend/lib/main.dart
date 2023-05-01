import 'package:aaryapay/global/authentication/authentication_bloc.dart';
import 'package:aaryapay/screens/Register/bloc/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:aaryapay/routes.dart';
import 'package:aaryapay/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: routes,
        title: 'AaryaPay',
        initialRoute: '/welcome',
        theme: AppTheme.lightTheme,
      ),
    );
  }
}
