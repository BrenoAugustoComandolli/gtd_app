import 'package:flutter/material.dart';
import 'package:gtd_app/consts/app_mgs_consts.dart';
import 'package:gtd_app/pages/coleta/coleta_page.dart';
import 'package:gtd_app/visual/cores_sistema.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selecionada = 0;

  static const List<Widget> _pages = [
    ColetaPage(),
    PlaceholderWidget(color: Colors.blue),
    PlaceholderWidget(color: Colors.green),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _pages[_selecionada],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.collections_bookmark_rounded),
              label: AppMgsConsts.titleColetaPage,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Business',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'School',
            ),
          ],
          currentIndex: _selecionada,
          selectedItemColor: CoresSistema.primaryColor,
          onTap: _onTapPage,
        ),
      ),
    );
  }

  void _onTapPage(int index) {
    setState(() => _selecionada = index);
  }
}

class PlaceholderWidget extends StatelessWidget {
  final Color color;

  const PlaceholderWidget({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}
