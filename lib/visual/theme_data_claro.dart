import 'package:flutter/material.dart';
import 'package:gtd_app/visual/cores_sistema.dart';
import 'package:gtd_app/visual/i_theme_data.dart';

class ThemeDataClaro implements IThemeData {
  @override
  ThemeData data() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: CoresSistema.primaryColor,
      ),
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.white,
        backgroundColor: CoresSistema.primaryColor,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      checkboxTheme: const CheckboxThemeData(
        side: BorderSide(
          width: 2,
          color: CoresSistema.primaryColor,
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: CoresSistema.primaryColor,
        actionTextColor: Colors.white,
      ),
      iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(7),
              ),
              side: BorderSide(
                color: Colors.black54,
              ),
            ),
          ),
        ),
      ),
      cardColor: CoresSistema.primaryColor,
      elevatedButtonTheme: const ElevatedButtonThemeData(
        style: ButtonStyle(
          iconColor: WidgetStatePropertyAll(Colors.white),
          foregroundColor: WidgetStatePropertyAll(Colors.white),
          backgroundColor: WidgetStatePropertyAll(
            CoresSistema.primaryColor,
          ),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: CoresSistema.primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: CoresSistema.primaryColor, width: 2),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: CoresSistema.primaryColor),
        ),
      ),
      textButtonTheme: const TextButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            CoresSistema.primaryColor,
          ),
          foregroundColor: WidgetStatePropertyAll(
            Colors.white,
          ),
        ),
      ),
      textTheme: const TextTheme(
        titleMedium: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      useMaterial3: true,
    );
  }
}
