// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/employee_list_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const StaffDirectoryApp());
}

class StaffDirectoryApp extends StatelessWidget {
  const StaffDirectoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Staff Directory',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const EmployeeListScreen(),
    );
  }
}
