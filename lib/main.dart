import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gtd_app/consts/app_mgs_consts.dart';
import 'package:gtd_app/pages/home/home_page.dart';
import 'package:gtd_app/visual/theme_data_claro.dart';
import 'package:gtd_app/visual/theme_data_escuro.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const AppWidget());
}

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppMgsConsts.title,
      theme: ThemeDataClaro().data(),
      darkTheme: ThemeDataEscuro().data(),
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}
