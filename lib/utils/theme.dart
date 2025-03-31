import 'package:app_sacc_licencias/utils/colors.dart';
import 'package:flutter/material.dart';

ThemeData darkTheme() {
  return ThemeData.dark().copyWith(
    appBarTheme: AppBarTheme(
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary, width: 2.0),
      ),
      floatingLabelStyle: TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.w500,
      ),
      border: OutlineInputBorder(),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: AppColors.primary,
      type: BottomNavigationBarType.fixed,
    ),
  );
}

ThemeData themeData() {
  return ThemeData(
    appBarTheme: AppBarTheme(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black, // Texto e íconos en AppBar
      elevation: 0,
    ),
    scaffoldBackgroundColor: Colors.grey[200],
    expansionTileTheme: ExpansionTileThemeData(
      backgroundColor: Colors.white,
      collapsedBackgroundColor: Colors.white,
      textColor: Colors.black,
      iconColor: Colors.black,
    ),

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primary,
      selectionHandleColor: AppColors.primary,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.primary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary, width: 2.0),
      ),
      floatingLabelStyle: TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.w500,
      ),
      border: OutlineInputBorder(),
    ),
    tabBarTheme: TabBarTheme(
      indicatorColor: AppColors.primary,
      labelColor: AppColors.primary,
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: AppColors.primary,
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
    ),
  );
}

Theme datePickerTheme(context, child) {
  return Theme(
    data: Theme.of(context).copyWith(
      colorScheme: ColorScheme.light(
        primary: AppColors.primary, // header background color
        // onPrimary: Colors.black, // header text color
        // onSurface: Colors.green, // body text color
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          // foregroundColor: Colors.red, // button text color
        ),
      ),
    ),
    child: child!,
  );
}
