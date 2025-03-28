import 'package:app_sacc_licencias/providers/loading_provider.dart';
import 'package:app_sacc_licencias/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends HookWidget {
  const SplashScreen({super.key});

  Future<void> _checkToken(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final loadingProvider = context.read<LoadingProvider>();
      loadingProvider.show();

      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('userToken');
      String? username = prefs.getString('username');
      String? password = prefs.getString('password');
      if (token != null && !isTokenExpired(token)) {
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        await prefs.remove('userToken');
        if (username != null && password != null) {
          if (context.mounted) {
            Navigator.pushReplacementNamed(
              context,
              '/login',
              arguments: {'useBiometric': true},
            );
          }
        } else {
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, '/login');
          }
        }
      }
      loadingProvider.hide();
    });
  }

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      _checkToken(context);
      return null;
    }, []);
    return const Scaffold();
  }
}
