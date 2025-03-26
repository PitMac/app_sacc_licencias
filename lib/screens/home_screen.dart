import 'package:app_sacc_licencias/screens/licencias_movil.dart';
import 'package:app_sacc_licencias/screens/licencias_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState(0);
    return Scaffold(
      body: IndexedStack(
        index: currentIndex.value,
        children: const [LicenciasWeb(), LicenciasMovil()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex.value,
        onTap: (value) => currentIndex.value = value,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor_rounded),
            label: "Web",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.mobile_screen_share),
            label: "Movil",
          ),
        ],
      ),
    );
  }
}
