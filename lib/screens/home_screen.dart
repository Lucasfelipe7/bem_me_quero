import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../screens/sugestoes_screen.dart';
import '../screens/historico_screen.dart';
import '../screens/hidratacao_config_screen.dart';
import '../screens/hidratacao_progresso_screen.dart';
import '../screens/lembrete_screen.dart';
import 'login_or_cadastro_flow.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginOrSignUpFlow()),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao fazer logout: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bem Me Quero")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
          children: [
            _buildFeatureCard(
              context,
              title: "Sugestões de Atividades",
              icon: Icons.lightbulb_outline,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SugestoesScreen()),
              ),
            ),
            _buildFeatureCard(
              context,
              title: "Histórico de Atividades",
              icon: Icons.history,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoricoScreen()),
              ),
            ),
            _buildFeatureCard(
              context,
              title: "Configuração de Meta de Hidratação",
              icon: Icons.local_drink,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HidratacaoConfigScreen()),
              ),
            ),
            _buildFeatureCard(
              context,
              title: "Progresso de Hidratação",
              icon: Icons.water_drop,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HidratacaoProgressoScreen()),
              ),
            ),
            _buildFeatureCard(
              context,
              title: "Lembretes de Hidratação",
              icon: Icons.alarm,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LembreteScreen()),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primary),
              child: const Text("Menu", style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: AppColors.secondary),
              title: const Text("Sair"),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: AppColors.background,
        shadowColor: AppColors.cardShadow,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: AppColors.secondary),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}