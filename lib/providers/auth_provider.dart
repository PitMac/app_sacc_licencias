import 'package:app_sacc_licencias/utils/instance.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final Dio _dio = DioClient().dio;

  Future<bool> logIn(
    BuildContext context,
    String username,
    String password,
  ) async {
    try {
      final response = await _dio.post(
        'usuario/login',
        data: {'usuario': username, 'clave': password},
      );

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userToken', response.data['data']['token']);

        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> logOut(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userToken');

    notifyListeners();

    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }
}
