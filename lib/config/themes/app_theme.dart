import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guard_chat/core/util/app_colors.dart';

ThemeData appTheme() {
  return ThemeData(
    useMaterial3: true,
    primaryColor: AppColors.primary,
    hintColor: AppColors.hint,
    brightness: Brightness.light,
    fontFamily: GoogleFonts.cairo().fontFamily,
    scaffoldBackgroundColor: AppColors.backgroundPrimary,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: AppColors.secondary,
      titleTextStyle: TextStyle(color: AppColors.textColorSecondary, fontSize: 20),
    ),
    textTheme: const TextTheme(
      labelLarge: TextStyle(
        fontSize: 16,
        color: AppColors.textColorPrimary,
        fontWeight: FontWeight.w500,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.backgroundSecondary,
      hintStyle: const TextStyle(fontSize: 14.0),
      contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
      enabledBorder: OutlineInputBorder(
        gapPadding: 0,
        borderSide: const BorderSide(color: AppColors.secondary, width: 0.3),
        borderRadius: BorderRadius.circular(32),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.secondary, width: 0.3),
        borderRadius: BorderRadius.circular(32),
      ),
    ),
  );
}
