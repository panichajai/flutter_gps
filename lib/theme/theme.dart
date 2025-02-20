import 'package:flutter/material.dart';

const primaryColor = Color(0xFF416FDF);
const onPrimaryColor = Color(0xFFFFFFFF);
const secondaryColor = Color(0xFF6EAEE7);
const onSecondaryColor = Color(0xFFFFFFFF);
const errorColor = Color(0xFFBA1A1A);
const onErrorColor = Color(0xFFFFFFFF);
const backgroundColor = Color(0xFFFCFDF6);
const onBackgroundColor = Color(0xFF1A1C18);
const surfaceColor = Color(0xFFF9FAF3);
const onSurfaceColor = Color(0xFF1A1C18);
const shadowColor = Color(0xFF000000);
const outlineVariantColor = Color(0xFFC2C8BC);

ThemeData appTheme = ThemeData(
  brightness: Brightness.light, // สามารถปรับได้ง่ายถ้าต้องการเปลี่ยนธีม
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: primaryColor,
    onPrimary: onPrimaryColor,
    secondary: secondaryColor,
    onSecondary: onSecondaryColor,
    error: errorColor,
    onError: onErrorColor,
    background: backgroundColor,
    onBackground: onBackgroundColor,
    surface: surfaceColor,
    onSurface: onSurfaceColor,
    shadow: shadowColor,
    outlineVariant: outlineVariantColor,
  ),
  appBarTheme: AppBarTheme(
    color: primaryColor,
    elevation: 0,
    iconTheme: IconThemeData(color: onPrimaryColor),
    actionsIconTheme: IconThemeData(color: onPrimaryColor),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
      foregroundColor: MaterialStateProperty.all<Color>(onPrimaryColor),
      elevation: MaterialStateProperty.all<double>(5.0),
      padding: MaterialStateProperty.all<EdgeInsets>(
        const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
  ),
);
