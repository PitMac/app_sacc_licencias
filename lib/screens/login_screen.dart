import 'package:app_sacc_licencias/providers/auth_provider.dart';
import 'package:app_sacc_licencias/providers/loading_provider.dart';
import 'package:app_sacc_licencias/widgets/alert_helper_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final username = useTextEditingController();
    final password = useTextEditingController();
    final seePassword = useState(false);
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Column(
        children: [
          TextFormField(
            controller: username,
            decoration: InputDecoration(
              labelText: 'Usuario',
              hintText: 'Usuario',
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: password,
            obscureText: !seePassword.value,
            decoration: InputDecoration(labelText: 'Clave', hintText: 'Clave'),
          ),
          ElevatedButton(
            onPressed: () => logIn(context, username.text, password.text),
            child: Text('Iniciar sesión'),
          ),
        ],
      ),
    );
  }
}
