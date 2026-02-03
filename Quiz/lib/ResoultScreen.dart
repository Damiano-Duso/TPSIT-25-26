//////////////////////////////////////////////////
//RESULTS SCREEN
class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

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