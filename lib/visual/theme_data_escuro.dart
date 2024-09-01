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
          color: Colors.white, // Mudança para branco, compatível com fundo escuro
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
                color: Colors.white, // Manter cor branca para contraste
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
          color: Colors.white, // Mudança para branco, compatível com fundo escuro
          fontSize: 20,
        ),
      ),
      useMaterial3: true,
    );
  }
}
