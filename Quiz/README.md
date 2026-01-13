# Quiz

## Descrizione del progetto

Quiz Game è un’applicazione sviluppata in **Flutter** che consente all’utente di svolgere un quiz a risposta multipla utilizzando le domande fornite dall’API pubblica **OpenTriviaDB**.

L’applicazione permette di selezionare il livello di difficoltà e il numero di domande, gestisce il caricamento dei dati tramite chiamate HTTP e mostra all’utente il risultato finale con punteggio e percentuale.

Il progetto ha uno scopo principalmente didattico ed è pensato per dimostrare l’uso di:

* chiamate API REST
* gestione dello stato in Flutter
* navigazione tra schermate
* dati JSON

## Posizione Codice
Il codice del gioco si trova dentro alla cartella "lib" e il file si chiama: "main.dart"

---

## Funzionalità principali

* Caricamento dinamico delle domande tramite API OpenTriviaDB
* Selezione della difficoltà (facile, media, difficile o tutte)
* Selezione del numero di domande (da 5 a 20)
* Visualizzazione di una domanda alla volta
* Barra di avanzamento del quiz
* Calcolo automatico del punteggio finale
* Schermata dei risultati con valutazione

---

## Struttura dell’applicazione

L’applicazione è suddivisa in tre schermate principali:

### HomeScreen

È la schermata iniziale dell’app. Permette all’utente di:

* selezionare la difficoltà del quiz
* scegliere il numero di domande
* avviare il quiz

### QuizScreen

È la schermata principale del gioco. Si occupa di:

* mostrare la domanda corrente
* visualizzare le possibili risposte
* gestire la selezione della risposta
* aggiornare il punteggio
* passare automaticamente alla domanda successiva

### ResultsScreen

È la schermata finale che mostra:

* il punteggio ottenuto
* il numero totale di domande
* la percentuale di risposte corrette
* un messaggio di valutazione

Da questa schermata è possibile tornare alla Home e ricominciare il quiz.

---

## Modello dei dati

### Classe `Question`

La classe `Question` rappresenta una singola domanda del quiz.

Attributi principali:

* categoria
* tipo di domanda
* difficoltà
* testo della domanda
* risposta corretta
* lista di tutte le risposte

La classe include un metodo factory che consente di creare un oggetto `Question` a partire dal JSON restituito dall’API.
Viene inoltre gestita la decodifica dei caratteri HTML presenti nelle stringhe.

---

## Servizi

### Classe `TriviaService`

La classe `TriviaService` si occupa delle chiamate HTTP verso l’API OpenTriviaDB.

Responsabilità principali:

* costruzione dell’URL con i parametri selezionati
* invio della richiesta GET
* controllo della risposta del server
* conversione dei dati JSON in una lista di oggetti `Question`

---

## API utilizzata

OpenTriviaDB è un servizio gratuito che fornisce domande per quiz.

Endpoint utilizzato:

```
https://opentdb.com/api.php
```

Parametri principali:

* `amount`: numero di domande
* `difficulty`: livello di difficoltà

---

## Tecnologie utilizzate

* Flutter
* Dart
* Package `http` per le chiamate di rete
* Material Design

---

## Avvio del progetto

Per eseguire l’applicazione:

1. Installare Flutter sul proprio sistema
2. Clonare o copiare il progetto
3. Aprire un terminale nella cartella del progetto
4. Eseguire i seguenti comandi:

```
flutter pub get
flutter run
```

## Damiano Duso