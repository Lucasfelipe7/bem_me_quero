import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../widgets/auth_checker.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/splash_success.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key, this.onTap});

  final void Function()? onTap;

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _cadastrar() async {
    if (_passwordController.value.text != _confirmPasswordController.value.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("As senhas não coincidem.")),
      );
      return;
    }

    final AuthService authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signUpWithEmailAndPassword(
        _emailController.value.text,
        _passwordController.value.text,
      );

      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final preferencias = await SharedPreferences.getInstance();
        await preferencias.setBool('isFirstTime', true);

        print("🎉 Novo usuário cadastrado! isFirstTime definido como true.");

        // Exibe o Splash de Sucesso após o cadastro
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return SplashSuccess(
              message: "Cadastro realizado com sucesso!",
              onDone: () {
                Navigator.of(context).pop(); // Fecha o Splash
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthChecker()),
                );
              },
            );
          },
        );
      }
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F2E7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFA4BFB9),
        title: Text('Cadastro', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 180,
                width: 180,
                child: Image.asset('images/Bem_me_quero-logo.png'),
              ),
              const Text(
                'Crie sua conta',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5A8F60), // Verde Folha
                ),
              ),
              SizedBox(height: 16),

              CustomTextField(
                controller: _emailController,
                label: 'E-mail',
                obscureText: false,
              ),
              SizedBox(height: 16),
              CustomTextField(
                controller: _passwordController,
                label: 'Senha',
                obscureText: true,
              ),
              SizedBox(height: 16),
              CustomTextField(
                controller: _confirmPasswordController,
                label: 'Confirmar Senha',
                obscureText: true,
              ),
              SizedBox(height: 24),
              CustomButton(
                text: 'Cadastrar',
                onPressed: _cadastrar,
                color: Color(0xFFF6F2E7),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Já possui uma conta? Faça login!',
                  style: TextStyle(
                    color: Color(0xFF5A8F60),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
