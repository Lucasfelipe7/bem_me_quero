import 'package:flutter/material.dart';
import '../models/tipo_autocuidado.dart';

class AutocuidadoCard extends StatelessWidget {
  final TipoAutocuidado tipo;
  final bool selecionado;
  final VoidCallback onTap;

  const AutocuidadoCard({
    super.key,
    required this.tipo,
    required this.selecionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Stack(
            children: [
              Card(
                color: Colors.transparent,
                shadowColor: Colors.black87,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    tipo.imagem,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              if (selecionado)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Color(0xFF7D9992).withOpacity(0.7),
                        width: 3,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          tipo.descricao,
          style: const TextStyle(
            color: Color(0xFF2D4C46),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
