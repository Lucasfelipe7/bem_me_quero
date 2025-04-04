import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/tipo_autocuidado_data.dart';
import '../widgets/autocuidado_card.dart';
import '../widgets/custom_button.dart';
import 'home_screen.dart';

class ConfiguracaoInicialScreen extends StatefulWidget {
  const ConfiguracaoInicialScreen({super.key});

  @override
  State<ConfiguracaoInicialScreen> createState() =>
      _ConfiguracaoInicialScreenState();
}

class _ConfiguracaoInicialScreenState extends State<ConfiguracaoInicialScreen> {
  final List<String> _selecionados = [];
  String _nomeUsuario = 'Usuário';

  @override
  void initState() {
    super.initState();
    _carregarPreferencias();
  }

  Future<void> _carregarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    final selecionadosSalvos = prefs.getStringList('autocuidado_selecionados') ?? [];
    final nomeSalvo = prefs.getString('nome_usuario') ?? 'Usuário';
    setState(() {
      _selecionados.clear();
      _selecionados.addAll(selecionadosSalvos);
      _nomeUsuario = nomeSalvo;
    });
  }

  Future<void> _salvarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();

    // Mapeia os nomes simples para os nomes completos
    final Map<String, String> mapeamentoNomes = {
      'Mental': 'Autocuidado Mental',
      'Social': 'Autocuidado Social',
      'Espiritual': 'Autocuidado Espiritual',
      'Físico': 'Autocuidado Físico',
      'Emocional': 'Autocuidado Emocional',
      'Sono': 'Autocuidado do Sono',
      'Digital': 'Autocuidado Digital',
    };

    final selecionadosCorrigidos = _selecionados.map((e) => mapeamentoNomes[e] ?? e).toList();

    await prefs.setStringList('autocuidado_selecionados', selecionadosCorrigidos);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Preferências salvas com sucesso!"),
        duration: Duration(seconds: 2),
      ),
    );
  }



  void _alternarSelecao(String nome) {
    setState(() {
      if (_selecionados.contains(nome)) {
        _selecionados.remove(nome);
      } else {
        _selecionados.add(nome);
      }
    });
  }

  void _concluirSelecao() async {
    if (_selecionados.isEmpty) {
      Future.delayed(Duration.zero, () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Por favor, selecione pelo menos um hábito de autocuidado."),
            duration: Duration(seconds: 2),
          ),
        );
      });
      return;
    }

    await _salvarPreferencias();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Escolha seus hábitos de autocuidado")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Bem-vindo, $_nomeUsuario! Que bom te ver aqui! 😊",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Escolha os hábitos que você já pratica ou quer começar. "
                      "Isso nos ajuda a oferecer sugestões personalizadas.",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: MasonryGridView.builder(
                itemCount: tiposAutocuidado.length,
                gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                itemBuilder: (context, index) {
                  final tipo = tiposAutocuidado[index];
                  final isSelecionado = _selecionados.contains(tipo.nome);

                  return AutocuidadoCard(
                    tipo: tipo,
                    selecionado: isSelecionado,
                    onTap: () => _alternarSelecao(tipo.nome),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 16.0),
            child: Builder(
              builder: (context) => CustomButton(
                text: "Concluir",
                onPressed: _selecionados.isNotEmpty
                    ? _concluirSelecao
                    : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Por favor, selecione pelo menos um hábito de autocuidado."),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                color: _selecionados.isNotEmpty ? const Color(0xFFA4BFB9) : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
