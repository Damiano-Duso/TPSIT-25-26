# todo_list

Applicazione Flutter semplice per gestire una lista di cose da fare (to-do).

## Descrizione

Questa app permette di creare, modificare e segnare come completate attività (task).

## Funzionalità principali

- Aggiunta, modifica e rimozione di task
- Segnare i task come completati
- Visualizzazione semplice delle statistiche (numero di task totali/completati)

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

- lib/ — codice principale (main.dart, Task.dart, ListaScreen.dart, StatsScreen.dart)
- android/, ios/, web/ — configurazioni e build per le piattaforme supportate da Flutter

## Dettagli del codice

**Funzioni principali:**

- main() : avvia l'app Flutter eseguendo runApp(MyApp()).
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
