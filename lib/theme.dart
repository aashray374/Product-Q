import 'package:flutter/material.dart';
import 'consts.dart';

class AppTheme {
  AppTheme._();

  static ThemeData theme = ThemeData().copyWith(
    //backgroundColor: MyConsts.bgColor,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
          fontFamily: 'Metropolis',
          fontSize: 36,
          fontWeight: FontWeight.w800,
          color: MyConsts.primaryDark),
      titleLarge: TextStyle(
          fontFamily: 'Metropolis',
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: MyConsts.bgColor),
      titleMedium: TextStyle(
          fontFamily: 'Metropolis',
          fontSize: 24,
          fontWeight: FontWeight.w900,
          color: MyConsts.bgColor),
      titleSmall: TextStyle(
        fontFamily: 'Metropolis',
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Mulish',
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: MyConsts.bgColor,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Mulish',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: MyConsts.bgColor,
      ),
      bodySmall: TextStyle(
          fontFamily: 'Mulish',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: MyConsts.primaryDark),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          contentPadding: const EdgeInsets.all(12),
          fillColor: Colors.white,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFCBCBCB)),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xFFCBCBCB),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          )),
    ),
    inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        contentPadding: const EdgeInsets.all(12),
        fillColor: Colors.white,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFCBCBCB)),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFFCBCBCB),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        )),
  );
}
