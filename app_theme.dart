// lib/theme/app_theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF1A3A5C);
  static const Color accentColor = Color(0xFF2E7D99);
  static const Color onDutyColor = Color(0xFF27AE60);
  static const Color onLeaveColor = Color(0xFFE67E22);
  static const Color homeColor = Color(0xFF8E44AD);
  static const Color cardBg = Color(0xFFF8FAFB);
  static const Color surfaceColor = Colors.white;

  static Color statusColor(String status) {
    switch (status) {
      case 'On Duty':
        return onDutyColor;
      case 'On Leave':
        return onLeaveColor;
      case 'Home':
        return homeColor;
      default:
        return Colors.grey;
    }
  }

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        scaffoldBackgroundColor: const Color(0xFFF0F4F8),
        cardTheme: CardTheme(
          elevation: 2,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          color: surfaceColor,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: accentColor, width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        chipTheme: ChipThemeData(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        ),
      );

  // Designation colors
  static Color designationColor(String designation) {
    switch (designation) {
      case 'CEO':
      case 'COO':
        return const Color(0xFF7B1FA2);
      case 'Senior Manager':
        return const Color(0xFFD32F2F);
      case 'Manager':
        return const Color(0xFFE64A19);
      case 'Deputy Manager':
        return const Color(0xFF1565C0);
      case 'Assistant':
        return const Color(0xFF00838F);
      case 'Senior Executive':
        return const Color(0xFF2E7D32);
      case 'Executive':
        return const Color(0xFF558B2F);
      case 'Junior Executive':
        return const Color(0xFF9E9D24);
      default:
        return Colors.grey.shade700;
    }
  }
}
