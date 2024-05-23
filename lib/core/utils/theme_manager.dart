

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'app_colors.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    highlightColor: Colors.transparent,
    // App bar theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: AppColors.textColorSecondary),
      elevation: 0,
    ),
    // main colors of the app
    primarySwatch: Colors.grey,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: AppColors.colorPrimary,
    primaryColorDark: AppColors.colorPrimary,
    disabledColor: AppColors.colorGray,
    colorScheme: ColorScheme.fromSwatch(
      backgroundColor: Colors.white,

    ),
    // ripple color
    splashColor: Colors.transparent,
    // card view theme
    cardTheme: const CardTheme(color: AppColors.offWhite, shadowColor: AppColors.colorGray, elevation: 1),
    // Button theme
    buttonTheme: ButtonThemeData(
        shape: const StadiumBorder(),
        disabledColor: AppColors.colorGray,
        buttonColor: AppColors.colorPrimary,
        splashColor: AppColors.colorPrimary.withOpacity(0.7)),
    fontFamily:'sfpro',
    // Text theme
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontSize: 12.sp, color: AppColors.textColorPrimary),
      bodyMedium: TextStyle(fontSize: 10.sp, color: AppColors.textColorSecondary),
      displayLarge: TextStyle(fontSize: 24.sp, color: AppColors.textColorPrimary),
      displayMedium: TextStyle(fontSize: 20.sp, color: AppColors.textColorPrimary),
      displaySmall: TextStyle(fontSize: 18.sp, color: AppColors.textColorPrimary),
      headlineMedium: TextStyle(fontSize: 14.sp, color: AppColors.textColorPrimary),
      headlineSmall: TextStyle(fontSize: 13.sp, color: AppColors.textColorPrimary),
      titleLarge: TextStyle(fontSize: 11.sp, color: AppColors.textColorPrimary),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders:{
              TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            },
    ),
  );
}
