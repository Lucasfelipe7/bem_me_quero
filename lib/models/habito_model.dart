class Habito {
  final String atividade;
  final DateTime date;
  bool completed;

  Habito({
    required this.atividade,
    required this.date,
    this.completed = false,
  });

  //converter o objeto Habit em um Map
  Map<String, dynamic> toMap() {
    return {
      'activity': atividade,
      'date': date.toIso8601String(),
      'completed': completed,
    };
  }

  // criar um objeto Habit a partir de um Map
  static Habito fromMap(Map<String, dynamic> map) {
    return Habito(
      atividade: map['activity'],
      date: DateTime.parse(map['date']),
      completed: map['completed'],
    );
  }
}
