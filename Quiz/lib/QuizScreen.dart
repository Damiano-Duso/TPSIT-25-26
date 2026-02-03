//////////////////////////////////////////////////
//QUIZ SCREEN
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

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