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
        backgroundColor: CoresSistema.primaryColor,
        titleTextStyle: TextStyle(
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
                color: Colors.black54,
              ),
            ),
          ),
        ),
      ),
      cardColor: CoresSistema.primaryColor,
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
