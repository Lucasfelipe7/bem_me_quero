import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_colors.dart';

class HidratacaoConfigScreen extends StatefulWidget {
  const HidratacaoConfigScreen({super.key});

  @override
  State<HidratacaoConfigScreen> createState() => _HidratacaoConfigScreenState();
}

class _HidratacaoConfigScreenState extends State<HidratacaoConfigScreen> {
  double _meta = 2.0;
  final TextEditingController _metaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarMeta();
  }

  Future<void> _carregarMeta() async {
    final prefs = await SharedPreferences.getInstance();
    final meta = prefs.getDouble('meta_hidratacao') ?? 2.0;
    setState(() {
      _meta = meta;
      _metaController.text = meta.toString();
    });
  }

  Future<void> _salvarMeta() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('meta_hidratacao', _meta);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Meta de hidratação salva com sucesso!'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meta de Hidratação', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Defina sua meta diária de ingestão de água (em litros):',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _metaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Litros',
                prefixIcon: const Icon(LucideIcons.droplet),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              style: const TextStyle(fontSize: 16),
              onChanged: (value) {
                setState(() {
                  _meta = double.tryParse(value) ?? _meta;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvarMeta,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Salvar Meta',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}