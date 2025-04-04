import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_colors.dart';

class SugestoesScreen extends StatefulWidget {
  const SugestoesScreen({super.key});

  @override
  State<SugestoesScreen> createState() => _SugestoesScreenState();
}

class _SugestoesScreenState extends State<SugestoesScreen> {
  List<String> _selecionados = [];
  List<String> _sugestoes = [];

  @override
  void initState() {
    super.initState();
    _carregarPreferencias();
  }

  Future<void> _carregarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    final selecionadosSalvos = prefs.getStringList(
        'autocuidado_selecionados') ?? [];
    setState(() {
      _selecionados = List<String>.from(selecionadosSalvos);
    });

    _gerarSugestoes();
  }

  void _gerarSugestoes() {
    final Map<String, List<String>> sugestoesPorCategoria = {
      'Autocuidado Mental': [
        'Pratique meditação por 10 minutos',
        'Leia um livro inspirador',
        'Faça uma pausa para respiração profunda'
      ],
      'Autocuidado Social': [
        'Converse com um amigo',
        'Envie uma mensagem para um familiar',
        'Participe de um evento social'
      ],
      'Autocuidado Espiritual': [
        'Pratique gratidão',
        'Leia um texto espiritual',
        'Faça uma caminhada em silêncio'
      ],
      'Autocuidado Físico': [
        'Faça alongamentos pela manhã',
        'Beba mais água',
        'Caminhe por pelo menos 30 minutos'
      ],
      'Autocuidado Emocional': [
        'Escreva um diário de sentimentos',
        'Ouça músicas relaxantes',
        'Pratique autocompaixão'
      ],
      'Autocuidado do Sono': [
        'Evite telas antes de dormir',
        'Crie uma rotina de sono regular',
        'Tome um chá relaxante antes de dormir'
      ],
      'Autocuidado Digital': [
        'Desconecte-se das redes sociais por uma hora',
        'Organize seus arquivos digitais',
        'Acompanhe o tempo de tela'
      ],
    };

    List<String> novasSugestoes = [];
    for (var categoria in _selecionados) {
      if (sugestoesPorCategoria.containsKey(categoria)) {
        novasSugestoes.addAll(sugestoesPorCategoria[categoria]!);
      }
    }

    setState(() {
      _sugestoes = novasSugestoes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Atividades de Autocuidado"),
        backgroundColor: AppColors.primary,
      ),
      body: _sugestoes.isEmpty
          ? const Center(child: Text("Nenhuma sugestão disponível"))
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Sugestões para você",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Container(
            height: 200,
            child: PageView.builder(
              itemCount: _sugestoes.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    color: AppColors.primary.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          _sugestoes[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}