import 'package:flutter/material.dart';
import 'dart:io';
import 'http_override.dart';
import 'package:flutter_gps/theme/theme.dart';
import 'package:flutter_gps/screens/welcome_screen.dart';
import 'package:flutter_gps/screens/tab_menu_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides(); // <- บรรทัดนี้ช่วยข้าม SSL error
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(375, 812));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: lightMode,
      // home: const TabMenuScreen(),
      home: const WelcomeScreen(),
    );
  }
}
