   //SCHERMATA STATS
class StatsScreen extends StatelessWidget {
  final List<Task> tasks;
     //Riceve la lista dei task dalla schermata Lista
  StatsScreen({required this.tasks});

  @override
  Widget build(BuildContext context) {
    int totale = tasks.length;
    int completati =
        tasks.where((task) => task.completato).length;
    int daFare = totale - completati;

    double efficienza =
        totale == 0 ? 0 : (completati / totale) * 100;

    return Scaffold(
      appBar: AppBar(title: Text('Statistiche')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Task inseriti: $totale',
                style: TextStyle(fontSize: 18)),
            Text('Task svolti: $completati',
                style: TextStyle(fontSize: 18)),
            Text('Task da svolgere: $daFare',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text(
              'Efficienza: ${efficienza.toStringAsFixed(1)}%',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
