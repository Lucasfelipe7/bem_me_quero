import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/configuracao_inicial_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_or_cadastro_flow.dart';

class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  Future<Widget> _getInitialScreen(User? user) async {
    if (user == null) return const LoginOrSignUpFlow();

    final preferencias = await SharedPreferences.getInstance();

    // Forçar reset temporário para testar o fluxo de primeiro login
    // await preferencias.remove('isFirstTime');

    bool isFirstTime = preferencias.getBool('isFirstTime') ?? true;

    print("🔍 isFirstTime = $isFirstTime"); // Depuração

    if (isFirstTime) {
      await preferencias.setBool('isFirstTime', false);
      return ConfiguracaoInicialScreen();
    }

    return const HomeScreen();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _getInitialScreen(FirebaseAuth.instance.currentUser),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return snapshot.data!;
      },
    );
  }
}
