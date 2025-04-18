import 'dart:io';

import 'package:app_sacc_licencias/providers/auth_provider.dart';
import 'package:app_sacc_licencias/providers/loading_provider.dart';
import 'package:app_sacc_licencias/providers/screen_provider.dart';
import 'package:app_sacc_licencias/providers/theme_provider.dart';
import 'package:app_sacc_licencias/utils/colors.dart';
import 'package:app_sacc_licencias/widgets/alert_helper_widget.dart';
import 'package:app_sacc_licencias/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends HookWidget {
  const LoginScreen({super.key});

  void logIn(BuildContext context, String username, String password) async {
    final loadingProvider = context.read<LoadingProvider>();
    final authProvider = context.read<AuthProvider>();
    if (username.isEmpty || password.isEmpty) {
      showAppAlert(
        context,
        type: 'error',
        title: 'Campos vacíos',
        description: 'Por favor complete ambos campos.',
        duration: 3,
      );
      return;
    }
    loadingProvider.show();
    bool success = await authProvider.logIn(context, username, password);
    if (success) {
      if (context.mounted) {
        showAppAlert(
          context,
          type: 'success',
          title: 'Bienvenido',
          description: 'Inicio de sesión exitoso',
          duration: 3,
        );
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      if (context.mounted) {
        showAppAlert(
          context,
          type: 'error',
          title: 'Error',
          description: 'Credenciales incorrectas.',
          duration: 3,
        );
      }
    }

    loadingProvider.hide();
  }

  Future<bool> _authenticateWithLinuxPassword() async {
    try {
      ProcessResult result = await Process.run('pkexec', [
        'echo',
        'Autenticado',
      ]);

      if (result.exitCode == 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> _authenticateBiometric(BuildContext context) async {
    final LocalAuthentication auth = LocalAuthentication();
    bool authenticated = false;

    if (Platform.isLinux) {
      authenticated = await _authenticateWithLinuxPassword();
    } else {
      bool canCheckBiometrics = await auth.canCheckBiometrics;

      if (canCheckBiometrics) {
        try {
          authenticated = await auth.authenticate(
            localizedReason: 'Autenticación con huella o Face ID',
            options: const AuthenticationOptions(biometricOnly: true),
          );
        } on PlatformException {
          authenticated = false;
        }
      }
    }

    if (authenticated) {
      final prefs = await SharedPreferences.getInstance();
      String? username = prefs.getString('username');
      String? password = prefs.getString('password');

      if (username != null && password != null && context.mounted) {
        logIn(context, username, password);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final username = useTextEditingController();
    final password = useTextEditingController();
    final seePassword = useState(false);
    final FocusNode usernameFocusNode = FocusNode();
    final FocusNode passwordFocusNode = FocusNode();
    final isDesktop = context.watch<ScreenProvider>().isDesktop;

    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final bool useBiometric = args?['useBiometric'] ?? false;

    final useBiometricState = useState(useBiometric);

    return Scaffold(
      body: Center(
        child: Container(
          width: isDesktop ? 400 : double.infinity,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo_empresa.png', height: 120),
              const SizedBox(height: 50),
              if (useBiometricState.value) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildLoginCard(
                      context,
                      icon: isDesktop ? Icons.password : Icons.fingerprint,
                      label: isDesktop ? "Clave" : "Huella/Face ID",
                      onTap: () => _authenticateBiometric(context),
                    ),
                    _buildLoginCard(
                      context,
                      icon: Icons.keyboard,
                      label: "Manual",
                      onTap: () => useBiometricState.value = false,
                    ),
                  ],
                ),
              ] else ...[
                KeyboardListener(
                  focusNode: usernameFocusNode,
                  onKeyEvent: (keyEvent) {
                    if (keyEvent.logicalKey == LogicalKeyboardKey.enter ||
                        keyEvent.logicalKey == LogicalKeyboardKey.numpadEnter) {
                      passwordFocusNode.requestFocus();
                    }
                  },
                  child: TextFormField(
                    controller: username,
                    decoration: InputDecoration(
                      labelText: 'Usuario',
                      hintText: 'Usuario',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                KeyboardListener(
                  focusNode: passwordFocusNode,
                  onKeyEvent: (keyEvent) {
                    if (keyEvent.logicalKey == LogicalKeyboardKey.enter ||
                        keyEvent.logicalKey == LogicalKeyboardKey.numpadEnter) {
                      logIn(context, username.text, password.text);
                    }
                  },
                  child: TextFormField(
                    controller: password,
                    obscureText: !seePassword.value,
                    decoration: InputDecoration(
                      labelText: 'Clave',
                      hintText: 'Clave',
                    ),
                  ),
                ),
                SizedBox(height: 30),
                customButton(
                  'Iniciar Sesión',
                  () => logIn(context, username.text, password.text),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          width: 150,
          height: 120,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).cardColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: AppColors.primary),
              SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
