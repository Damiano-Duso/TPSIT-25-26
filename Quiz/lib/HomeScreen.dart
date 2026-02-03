//////////////////////////////////////////////////
//HOME SCREEN
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
              initialValue: selectedDifficulty,
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