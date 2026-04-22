import 'package:flutter/material.dart';
import 'Task.dart';
import 'StatsScreen.dart';
import 'DatabaseHelper.dart';

//SCHERMATA LISTA
class ListaScreen extends StatefulWidget {
  @override
  _ListaScreenState createState() => _ListaScreenState();
}

class _ListaScreenState extends State<ListaScreen> {
  List<Task> tasks = []; // Lista principale dei task
  TextEditingController controller = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadTasks(); // Carica i task dal database all'avvio
  }

  // Carica i task dal database
  Future<void> _loadTasks() async {
    final loadedTasks = await _dbHelper.getAllTasks();
    setState(() {
      tasks = loadedTasks;
    });
  }

  // Metodo per aggiungere un nuovo task
  Future<void> aggiungiTask() async {
    if (controller.text.isNotEmpty) {
      Task newTask = Task(
        titolo: controller.text,
        completato: false,
      );

      // Inserisce nel database
      int id = await _dbHelper.insertTask(newTask);
      newTask.id = id; // Assegna l'ID generato dal database

      setState(() {
        tasks.add(newTask);
        controller.clear();
      });
    }
  }

  // Metodo per marcare un task come completato/non completato
  Future<void> _toggleTask(int index, bool value) async {
    tasks[index].completato = value;
    await _dbHelper.updateTask(tasks[index]);
    setState(() {});
  }

  // Metodo per eliminare un task
  Future<void> _deleteTask(int index) async {
    if (tasks[index].id != null) {
      await _dbHelper.deleteTask(tasks[index].id!);
    }
    setState(() {
      tasks.removeAt(index);
    });
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
                return ListTile(
                  leading: Checkbox(
                    value: tasks[index].completato,
                    onChanged: (value) {
                      _toggleTask(index, value!);
                    },
                  ),
                  title: Text(tasks[index].titolo),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _deleteTask(index);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}