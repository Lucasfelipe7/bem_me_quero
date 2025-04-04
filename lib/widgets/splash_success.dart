import 'package:flutter/material.dart';

class SplashSuccess extends StatelessWidget {
  const SplashSuccess({
    super.key,
    required this.onDone,
    this.message = "Cadastro realizado com sucesso!",
    this.duration = const Duration(seconds: 2), // Delay de 2 segundos
  });

  final VoidCallback onDone;
  final String message;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    // Exibe o splash e aplica o delay
    Future.delayed(duration, onDone);

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 10),
            Text(message),
          ],
        ),
      ),
    );
  }
}
