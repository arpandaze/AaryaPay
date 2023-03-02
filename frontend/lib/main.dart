import 'package:flutter/material.dart';
import 'package:aaryapay/routes.dart';
import 'package:aaryapay/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: routes,
      title: 'Flutter Demo',
      initialRoute: '/home',
      theme: AppTheme.lightTheme,
    );
  }
}
