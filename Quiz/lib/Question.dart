//////////////////////////////////////////////////
//MODELLO DATI
//Rappresenta una singola domanda del quiz con tutte le sue informazioni
class Question {
  final String category;      //Categoria della domanda ("Storia", "Geografia")
  final String type;          //Tipo di domanda ("multiple", "boolean")
  final String difficulty;    //Difficoltà (easy, medium, hard)
  final String question;      //Testo della domanda
  final String correctAnswer; //Risposta corretta
  final List<String> allAnswers; //Lista di tutte le risposte (mescolate)


  Question({
    required this.category,
    required this.type,
    required this.difficulty,
    required this.question,
    required this.correctAnswer,
    required this.allAnswers,
  });

  //Crea una domanda, crea una lista con le risposte e la mescola
  factory Question.fromJson(Map<String, dynamic> json) {
    List<String> answers = List<String>.from(json['incorrect_answers']);
    answers.add(json['correct_answer']);
    answers.shuffle();

    return Question(
      category: json['category'],
      type: json['type'],
      difficulty: json['difficulty'],
      question: _decodeHtml(json['question']),           
      correctAnswer: _decodeHtml(json['correct_answer']),
      allAnswers: answers.map((a) => _decodeHtml(a)).toList(),
    );
  }


  //OpenTriviaDB restituisce caratteri speciali in formato HTML (es. &quot; per ")
  static String _decodeHtml(String text) {
    return text
        .replaceAll('&quot;', '"')    
        .replaceAll('&amp;', '&')     
        .replaceAll('&#039;', "'")    
        .replaceAll('&lt;', '<')      
        .replaceAll('&gt;', '>')      
        .replaceAll('&ldquo;', '"')   
        .replaceAll('&rdquo;', '"')   
        .replaceAll('&rsquo;', "'");  
  }
}