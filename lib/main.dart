import 'package:app_sacc_licencias/providers/auth_provider.dart';
import 'package:app_sacc_licencias/providers/loading_provider.dart';
import 'package:app_sacc_licencias/screens/form_movil_screen.dart';
import 'package:app_sacc_licencias/screens/form_web_screen.dart';
import 'package:app_sacc_licencias/screens/home_screen.dart';
import 'package:app_sacc_licencias/screens/login_screen.dart';
import 'package:app_sacc_licencias/screens/reporte_screen.dart';
import 'package:app_sacc_licencias/screens/splash_screen.dart';
import 'package:app_sacc_licencias/utils/theme.dart';
import 'package:app_sacc_licencias/widgets/global_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoadingProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Licencia App',
      debugShowCheckedModeBanner: false,
      theme: themeData(),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/web': (context) => FormWebScreen(),
        '/movil': (context) => FormMovilScreen(),
        '/reporte': (context) => ReporteScreen(),
      },
      builder: (context, child) {
        return Stack(children: [child!, GlobalLoadingWidget()]);
      },
    );
  }
}
