import 'package:flutter/material.dart';
import 'package:aaryapay/routes.dart';
import 'package:aaryapay/theme.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: routes,
      title: 'Flutter Demo',
      initialRoute: '/welcome',
      theme: AppTheme.lightTheme,
    );
  }
}
