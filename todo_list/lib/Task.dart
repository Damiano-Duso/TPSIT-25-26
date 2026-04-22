class Task {
  int? id; // ID del database (null per nuovi task)
  String titolo;
  bool completato;

  Task({this.id, required this.titolo, required this.completato});

  // Converte un Task a mappa per il database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titolo': titolo,
      'completato': completato ? 1 : 0,
    };
  }

  // Crea un Task da una mappa del database
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int,
      titolo: map['titolo'] as String,
      completato: map['completato'] == 1,
    );
  }
}