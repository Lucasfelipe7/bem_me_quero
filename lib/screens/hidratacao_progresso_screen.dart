import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_colors.dart';

class HidratacaoProgressoScreen extends StatefulWidget {
  const HidratacaoProgressoScreen({super.key});

  @override
  State<HidratacaoProgressoScreen> createState() => _HidratacaoProgressoScreenState();
}

class _HidratacaoProgressoScreenState extends State<HidratacaoProgressoScreen> {
  double _meta = 2.0;
  double _progresso = 0.0;
  final TextEditingController _quantidadeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarMeta();
  }

  Future<void> _carregarMeta() async {
    final prefs = await SharedPreferences.getInstance();
    final meta = prefs.getDouble('meta_hidratacao') ?? 2.0;
    final progresso = prefs.getDouble('progresso_hidratacao') ?? 0.0;
    setState(() {
      _meta = meta;
      _progresso = progresso;
    });
  }

  Future<void> _salvarProgresso() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('progresso_hidratacao', _progresso);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Progresso salvo!'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _resetarProgresso() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('progresso_hidratacao', 0.0);
    setState(() {
      _progresso = 0.0;
    });
  }

  void _registrarIngestao() {
    final quantidade = double.tryParse(_quantidadeController.text) ?? 0.0;
    if (quantidade > 0) {
      setState(() {
        _progresso += quantidade;
        if (_progresso >= _meta) {
          _progresso = _meta;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Parabéns! Você atingiu sua meta de hidratação! 🎉'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      });
      _quantidadeController.clear();
      _salvarProgresso();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progresso de Hidratação', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetarProgresso,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Meta diária: ${_meta.toStringAsFixed(1)} L',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: _progresso / _meta,
                    strokeWidth: 10,
                    backgroundColor: AppColors.buttonDisabled,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  '${_progresso.toStringAsFixed(1)}L',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _quantidadeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Quantidade ingerida (L)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registrarIngestao,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Registrar Ingestão',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
