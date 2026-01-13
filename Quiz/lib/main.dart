import 'package:flutter/material.dart';
import 'dart:convert';                   
import 'package:http/http.dart' as http; 
import 'dart:async';                     

//////////////////////////////////////////////////
//MAIN
void main() {
  runApp(const QuizApp());
}

//////////////////////////////////////////////////
//WIDGET PRINCIPALE DELL'APP
class QuizApp extends StatelessWidget {
  const QuizApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //Definizione delle rotte per la navigazione tra schermate
      initialRoute: '/',  //Schermata iniziale
      routes: {
        '/': (context) => const HomeScreen(),      //Home
        '/quiz': (context) => const QuizScreen(),  //Quiz
        '/results': (context) => const ResultsScreen(), //Risultati
      },
    );
  }
}

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

//////////////////////////////////////////////////
//SERVICE
//Classe per gestire le chiamate API
class TriviaService {
  static const String baseUrl = 'https://opentdb.com/api.php';

  //Metodo per recuperare le domande dall'API
  static Future<List<Question>> fetchQuestions({
    int amount = 10,           
    String? category,         
    String? difficulty,      
  }) async {
    String url = '$baseUrl?amount=$amount';
    if (category != null) url += '&category=$category';
    if (difficulty != null) url += '&difficulty=$difficulty';

    //chiamata HTTP GET
    final response = await http.get(Uri.parse(url));

    //(status code 200)
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      //successo nell'API di OpenTriviaDB
      if (data['response_code'] == 0) {
        return (data['results'] as List)
            .map((q) => Question.fromJson(q))
            .toList();
      }
    }
    throw Exception('Errore nel caricamento delle domande');
  }
}

//////////////////////////////////////////////////
//HOME SCREEN
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

//State della Home Screen - contiene le variabili che possono cambiare
class _HomeScreenState extends State<HomeScreen> {
  String? selectedDifficulty;  //Difficoltà selezionata (null = tutte)
  int numberOfQuestions = 10;  //Numero di domande da caricare

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Barra superiore
      appBar: AppBar(
        title: const Text('Quiz Game'),
        centerTitle: true,
      ),
      //Corpo della schermata
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //Icona del quiz
            const Icon(
              Icons.quiz,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            
            //Titolo
            const Text(
              'Quiz Game',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            
            //Dropdown per selezionare la difficoltà
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Difficoltà',
                border: OutlineInputBorder(),
              ),
              value: selectedDifficulty,
              items: const [
                DropdownMenuItem(value: null, child: Text('Tutte')),
                DropdownMenuItem(value: 'easy', child: Text('Facile')),
                DropdownMenuItem(value: 'medium', child: Text('Medio')),
                DropdownMenuItem(value: 'hard', child: Text('Difficile')),
              ],
              onChanged: (value) {
                //Aggiorna lo stato quando l'utente seleziona una difficoltà
                setState(() {
                  selectedDifficulty = value;
                });
              },
            ),
            const SizedBox(height: 20),
            
            //Selettore numero di domande
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Numero di domande:',
                  style: TextStyle(fontSize: 16),
                ),
                Row(
                  children: [
                    //Pulsante per decrementare
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: numberOfQuestions > 5
                          ? () => setState(() => numberOfQuestions--)
                          : null, //Disabilita se siamo al minimo (5)
                    ),
                    //Visualizza il numero corrente
                    Text(
                      '$numberOfQuestions',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    //Pulsante per incrementare
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: numberOfQuestions < 20
                          ? () => setState(() => numberOfQuestions++)
                          : null, //Disabilita se siamo al massimo (20)
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),
            
            //Pulsante per iniziare il quiz
            ElevatedButton(
              onPressed: () {
                //Naviga alla schermata del quiz passando i parametri
                Navigator.pushNamed(
                  context,
                  '/quiz',
                  arguments: {
                    'amount': numberOfQuestions,
                    'difficulty': selectedDifficulty,
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Inizia Quiz',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////
//QUIZ SCREEN
class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

//gestisce la logica del quiz
class _QuizScreenState extends State<QuizScreen> {
  //Variabili di stato
  List<Question> questions = [];       //Lista delle domande
  int currentQuestionIndex = 0;        //Indice della domanda
  int score = 0;                       //Punteggio
  bool isLoading = true;               //caricamento
  String? selectedAnswer;              //Risposta selezionata
  bool hasAnswered = false;            //risposta

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //Carica le domande solo una volta
    if (isLoading) {
      loadQuestions();
    }
  }

  //Metodo asincrono per caricare le domande dall'API
  Future<void> loadQuestions() async {
    //Recupera gli argomenti passati dalla schermata precedente
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    try {
      //Chiama il service per ottenere le domande
      final loadedQuestions = await TriviaService.fetchQuestions(
        amount: args['amount'],
        difficulty: args['difficulty'],
      );
      //Aggiorna lo stato con le domande caricate
      setState(() {
        questions = loadedQuestions;
        isLoading = false;
      });
    } catch (e) {
      //In caso di errore, mostra un messaggio e torna indietro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore: $e')),
      );
      Navigator.pop(context);
    }
  }

  //Metodo per verificare la risposta selezionata
  void checkAnswer(String answer) {
    //Se l'utente ha già risposto, ignora ulteriori click
    if (hasAnswered) return;

    //Aggiorna lo stato
    setState(() {
      selectedAnswer = answer;
      hasAnswered = true;
      //Se la risposta è corretta, incrementa il punteggio
      if (answer == questions[currentQuestionIndex].correctAnswer) {
        score++;
      }
    });

    Timer(const Duration(seconds: 1), () {
      if (currentQuestionIndex < questions.length - 1) {
        setState(() {
          currentQuestionIndex++;
          selectedAnswer = null;
          hasAnswered = false;
        });
      } else {
        Navigator.pushReplacementNamed(
          context,
          '/results',
          arguments: {
            'score': score,
            'total': questions.length,
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Caricamento...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final question = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Domanda ${currentQuestionIndex + 1}/${questions.length}'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                'Punteggio: $score',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //Barra di progresso
            LinearProgressIndicator(
              value: (currentQuestionIndex + 1) / questions.length,
            ),
            const SizedBox(height: 30),
            
            //Categoria della domanda
            Text(
              question.category,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            
            
            Text(
              question.question,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            
            
            Expanded(
              child: ListView.builder(
                itemCount: question.allAnswers.length,
                itemBuilder: (context, index) {
                  final answer = question.allAnswers[index];
                  Color? buttonColor;

                  
                  if (hasAnswered) {
                    if (answer == question.correctAnswer) {
                      buttonColor = Colors.green; 
                    } else if (answer == selectedAnswer) {
                      buttonColor = Colors.red;
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: ElevatedButton(
                      //Disabilita il pulsante dopo aver risposto
                      onPressed: hasAnswered ? null : () => checkAnswer(answer),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: buttonColor,
                      ),
                      child: Text(
                        answer,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////
//RESULTS SCREEN
class ResultsScreen extends StatelessWidget {
  const ResultsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Recupera i parametri passati dalla schermata precedente
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final score = args['score'] as int;      //Punteggio ottenuto
    final total = args['total'] as int;      //Numero totale di domande
    final percentage = (score / total * 100).round(); //Percentuale

    //Determina il messaggio in base alla percentuale
    String message;
    if (percentage >= 80) {
      message = 'Eccellente!';
    } else if (percentage >= 60) {
      message = 'Ottimo!';
    } else if (percentage >= 40) {
      message = 'Buon tentativo!';
    } else {
      message = 'Continua a studiare!';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Risultati'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              Text(
                message,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              
              
              Text(
                '$score/$total',
                style: const TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),
              
              
              Text(
                '$percentage%',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 60),
              
            
              ElevatedButton(
                onPressed: () {
                
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: const Text(
                  'Torna alla Home',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}