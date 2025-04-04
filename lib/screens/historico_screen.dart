import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../models/habito_model.dart';

class HistoricoScreen extends StatefulWidget {
  const HistoricoScreen({super.key});

  @override
  State<HistoricoScreen> createState() => _HistoricoScreenState();
}

class _HistoricoScreenState extends State<HistoricoScreen> {
  List<Habito> _historico = [];

  @override
  void initState() {
    super.initState();
    simularHistorico();
    carregarHistorico();
  }

  //simular o histórico de atividades
  Future<void> simularHistorico() async {
    final prefs = await SharedPreferences.getInstance();


    List<Habito> simulados = [
      Habito(atividade: "Meditação", date: DateTime.now(), completed: true),
      Habito(atividade: "Exercícios físicos", date: DateTime.now().subtract(Duration(days: 1)), completed: false),
      Habito(atividade: "Leitura", date: DateTime.now().subtract(Duration(days: 2)), completed: true),
    ];

    final habitListMap = simulados.map((habit) => habit.toMap()).toList();

    final habitString = jsonEncode(habitListMap);

    await prefs.setString('historico', habitString);

    print("Dados simulados salvos: $habitString");
  }

  //carregar o histórico de atividades
  Future<void> carregarHistorico() async {
    final prefs = await SharedPreferences.getInstance();
    final habitString = prefs.getString('historico') ?? '[]';
    final List<dynamic> habitList = jsonDecode(habitString);

    setState(() {
      _historico = habitList.map((item) => Habito.fromMap(item)).toList();
    });
  }

  //formatar a data
  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Map<String, List<Habito>> groupByDate(List<Habito> habits) {
    Map<String, List<Habito>> grouped = {};
    for (var habit in habits) {
      String dateKey = DateFormat('dd/MM/yyyy').format(habit.date);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]?.add(habit);
    }
    return grouped;
  }


  void _editarHabito(Habito habit) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditHabitoScreen(habit: habit),
      ),
    );

    if (result != null) {
      setState(() {
        int index = _historico.indexOf(habit);
        _historico[index] = result;
      });

      // Atualiza o SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final habitListMap = _historico.map((habit) => habit.toMap()).toList();
      final habitString = jsonEncode(habitListMap);
      await prefs.setString('historico', habitString);
    }
  }

  void _excluirHabito(Habito habit) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _historico.remove(habit);
    });

    final habitListMap = _historico.map((habit) => habit.toMap()).toList();
    final habitString = jsonEncode(habitListMap);
    await prefs.setString('historico', habitString);
    print("Hábito excluído: ${habit.atividade}");
  }

  @override
  Widget build(BuildContext context) {
    final groupedHabits = groupByDate(_historico);

    return Scaffold(
      appBar: AppBar(title: const Text("Histórico de Atividades")),
      body: groupedHabits.isEmpty
          ? const Center(child: Text("Nenhum histórico disponível"))
          : ListView.builder(
        itemCount: groupedHabits.keys.length,
        itemBuilder: (context, index) {
          String dateKey = groupedHabits.keys.elementAt(index);
          List<Habito> habitsOnThisDate = groupedHabits[dateKey]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  dateKey,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              ...habitsOnThisDate.map((habit) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  elevation: 4.0,
                  shadowColor: AppColors.cardShadow,
                  child: ListTile(
                    title: Text(habit.atividade),
                    subtitle: Text('${formatDate(habit.date)}'),
                    tileColor: habit.completed
                        ? AppColors.textGreen.withOpacity(0.1)
                        : AppColors.buttonYellow.withOpacity(0.1),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: AppColors.accent),
                          onPressed: () {
                            _editarHabito(habit);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: AppColors.secondary),
                          onPressed: () {
                            _excluirHabito(habit);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}


class EditHabitoScreen extends StatefulWidget {
  final Habito habit;

  const EditHabitoScreen({Key? key, required this.habit}) : super(key: key);

  @override
  _EditHabitoScreenState createState() => _EditHabitoScreenState();
}

class _EditHabitoScreenState extends State<EditHabitoScreen> {
  late TextEditingController _activityController;
  late bool _completed;

  @override
  void initState() {
    super.initState();
    _activityController = TextEditingController(text: widget.habit.atividade);
    _completed = widget.habit.completed;
  }

  @override
  void dispose() {
    _activityController.dispose();
    super.dispose();
  }

  void _save() {
    final updatedHabit = Habito(
      atividade: _activityController.text,
      date: widget.habit.date,
      completed: _completed,
    );

    Navigator.pop(context, updatedHabit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Hábito")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _activityController,
              decoration: const InputDecoration(labelText: 'Atividade'),
            ),
            SwitchListTile(
              title: const Text('Concluído'),
              value: _completed,
              onChanged: (value) {
                setState(() {
                  _completed = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: _save,
              child: const Text("Salvar"),
            ),
          ],
        ),
      ),
    );
  }
}