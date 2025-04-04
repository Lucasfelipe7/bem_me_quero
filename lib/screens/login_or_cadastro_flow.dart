import 'package:flutter/material.dart';

import 'cadastro_screen.dart';
import 'login_screen.dart';

class LoginOrSignUpFlow extends StatefulWidget {
  const LoginOrSignUpFlow({super.key});

  @override
  State<LoginOrSignUpFlow> createState() => _LoginOrSignUpFlowState();
}

class _LoginOrSignUpFlowState extends State<LoginOrSignUpFlow> {
  bool shouldShowLoginPage = true;

  void togglePages() {
    setState(() {
      shouldShowLoginPage = !shouldShowLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: shouldShowLoginPage
                ? LoginScreen(onTap: togglePages)
                : CadastroScreen(onTap: togglePages),
          ),
        ],
      ),
    );
  }
}
