import 'package:flutter/material.dart';
import 'package:gtd_app/visual/cores_sistema.dart';
import 'package:gtd_app/visual/i_theme_data.dart';

class ThemeDataEscuro implements IThemeData {
  @override
  ThemeData data() {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: CoresSistema.primaryColor,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: CoresSistema.primaryColor,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
      textTheme: const TextTheme(
        titleMedium: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
      iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(7),
              ),
              side: BorderSide(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      cardColor: CoresSistema.primaryColor,
      useMaterial3: true,
    );
  }
}
