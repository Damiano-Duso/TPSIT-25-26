   //SCHERMATA LISTA
class ListaScreen extends StatefulWidget {
  @override
  _ListaScreenState createState() => _ListaScreenState();
}

class _ListaScreenState extends State<ListaScreen> {
  List<Task> tasks = []; // Lista principale dei task
  TextEditingController controller = TextEditingController();

  // Metodo per aggiungere un nuovo task
  void aggiungiTask() {
    if (controller.text.isNotEmpty) {
      setState(() {
        tasks.add(Task(controller.text, false));
        controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista Task'),
        actions: [
          IconButton(
            icon: Icon(Icons.bar_chart),
            onPressed: () {
              /* passa la lista di tasks
                 alla schermata StatsScreen tramite il costruttore
              */
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StatsScreen(tasks: tasks),
                ),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: 'Nuovo task',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: aggiungiTask,
                )
              ],
            ),
          ),

          // Lista dei task
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(tasks[index].titolo),
                  value: tasks[index].completato,
                  onChanged: (value) {
                    setState(() {
                      tasks[index].completato = value!;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}