# todo_list

Applicazione Flutter semplice per gestire una lista di cose da fare (to-do) con persistenza dei dati tramite SQLite.

## Descrizione

Questa app permette di creare, modificare, marcare come completate e eliminare attività (task). I dati vengono salvati automaticamente in un database SQLite locale, quindi i task persisteranno anche dopo aver chiuso l'app.

## Funzionalità principali

- Aggiunta di nuovi task
- Marcatura dei task come completati/non completati
- Eliminazione di task
- **Salvataggio tramite SQLite** - I task vengono salvati automaticamente
- Visualizzazione delle statistiche (numero di task totali/completati/da fare e percentuale di efficienza)

## Tecnologie utilizzate

- **Flutter** - Framework per lo sviluppo cross-platform
- **SQLite** (sqflite) - Database locale per i dati
- **Dart** - Linguaggio di programmazione

## File del progetto

- `lib/main.dart` - Punto di ingresso dell'applicazione
- `lib/ListaScreen.dart` - Schermata principale con la lista dei task (ora con persistenza)
- `lib/StatsScreen.dart` - Schermata delle statistiche
- `lib/Task.dart` - Modello per rappresentare un task (con supporto serializzazione database)
- `lib/DatabaseHelper.dart` - Classe helper per la gestione del database SQLite

## Requisiti

- Flutter SDK (versione stabile consigliata)
- Ambiente di sviluppo per Flutter (Android Studio, VS Code, ecc.)

## Avvio

1. Installare le dipendenze:

```
flutter pub get
```

2. Avviare l'app su un dispositivo o emulatore:

```
flutter run
```

## Struttura del progetto

- `lib/` - Codice principale dell'app
  - `main.dart` - Punto di ingresso
  - `Task.dart` - Modello Task con serializzazione
  - `ListaScreen.dart` - Schermata lista (con salvataggio SQLite)
  - `StatsScreen.dart` - Schermata statistiche
  - `DatabaseHelper.dart` - Helper per le operazioni SQLite
- `android/`, `ios/`, `web/` - Configurazioni e build per le piattaforme supportate da Flutter

## Dettagli del codice

**Funzioni principali:**

- `main()` - Avvia l'app Flutter eseguendo `runApp(MyApp())`
- `ListaScreen` - Gestisce l'interfaccia principale con:
  - Caricamento dei task dal database all'avvio (`_loadTasks()`)
  - Aggiunta di nuovi task con salvataggio automatico (`aggiungiTask()`)
  - Marcatura task completati con aggiornamento database (`_toggleTask()`)
  - Eliminazione di task (`_deleteTask()`)
- `DatabaseHelper` - Singleton che gestisce tutte le operazioni SQLite:
  - `insertTask()` - Inserisce un nuovo task nel database
  - `getAllTasks()` - Recupera tutti i task dal database
  - `updateTask()` - Aggiorna un task esistente
  - `deleteTask()` - Elimina un task dal database
- `Task` - Modello con metodi di serializzazione:
  - `toMap()` - Converte il task a mappa per il database
  - `fromMap()` - Crea un task da una mappa del database

## dati

I task vengono salvati automaticamente in un database SQLite locale. Quando l'app viene chiusa e riaprerta, i task precedentemente salvati vengono automaticamente caricati e ripristinati nella lista.
- MyApp : widget principale che imposta MaterialApp con ListaScreen come home.
- ListaScreen (Stateful) : contiene la lista dei task, il campo di input e la UI per aggiungere/checkare task. Metodo importante:
- aggiungiTask() : legge controller.text, crea un nuovo Task e chiama setState() per aggiornare la UI.
- StatsScreen (Stateless) : riceve la lista di Task e calcola statistiche (totale, completati, da fare, efficienza).

**Variabili principali:**

- List<Task> tasks (in _ListaScreenState) — lista principale dei task mostrata nella schermata Lista.
- TextEditingController controller — gestisce il testo dell'input per nuovi task.
- Task.titolo — stringa con il testo del task.
- Task.completato — booleano che indica se il task è completato.
- int totale, int completati, int daFare, double efficienza (in StatsScreen) — variabili derivate per le statistiche.

**Passaggio dei dati tra schermate:**

- I dati vengono passati dalla ListaScreen alla StatsScreen tramite il costruttore della schermata, usando Navigator.push con MaterialPageRoute:

```dart
Navigator.push(
	context,
	MaterialPageRoute(
		builder: (context) => StatsScreen(tasks: tasks),
	),
);
```

- In pratica si passa il riferimento alla List<Task> corrente. StatsScreen legge lo stato della lista al momento della creazione della schermata e calcola le statistiche. Le modifiche successive alla lista nella ListaScreen non aggiornano automaticamente la StatsScreen già aperta (la schermata riceve la lista come snapshot/reference al momento della push).

**Note sullo stato:**

- La ListaScreen usa setState() per aggiornare la UI quando cambia tasks o lo stato di un singolo task.
- StatsScreen è stateless e si limita a leggere la lista fornita e calcolare valori derivati.

---
