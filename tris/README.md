# Tris Online

Applicazione mobile Flutter per giocare a Tris (Tic-Tac-Toe) a distanza tra due giocatori, con comunicazione via socket TCP.

## Architettura

```
tris/
├── server.dart                      # Server TCP per gestire le connessioni e la logica di gioco
├── lib/
│   ├── main.dart                    # Punto di ingresso dell'app Flutter
│   ├── config/
│   │   └── constants.dart           # Costanti di configurazione per client/server e UI
│   ├── models/
│   │   └── game_model.dart          # Modello dello stato della partita Tris
│   ├── services/
│   │   └── game_service.dart        # Servizio per la comunicazione TCP dal client
│   └── screens/
│       ├── connection_screen.dart   # Schermata di login/connessione al server
│       └── game_screen.dart         # Schermata del gioco con griglia e stato
└── pubspec.yaml
```

## Descrizione dei file

- `server.dart`: server Dart che accetta due client, abbina i giocatori e gestisce l'aggiornamento dello stato del gioco.
- `lib/main.dart`: avvia l'app Flutter e mostra la schermata di connessione iniziale.
- `lib/config/constants.dart`: contiene valori di configurazione riutilizzabili come porta, host di default e messaggi di UI.
- `lib/models/game_model.dart`: modella la griglia del Tris, il turno corrente e lo stato del gioco.
- `lib/services/game_service.dart`: gestisce il socket TCP, invia azioni JSON al server e riceve aggiornamenti di stato.
- `lib/screens/connection_screen.dart`: pagina dove l'utente inserisce host e porta del server e avvia la connessione.
- `lib/screens/game_screen.dart`: mostra la griglia del gioco, riceve aggiornamenti dal server e invia le mosse.

## Installazione

1. Installare dipendenze:
```bash
flutter pub get
```

2. Avviare il server:
```bash
dart server.dart
```

3. Avviare l'app (su due dispositivi):
```bash
flutter run
```

## Come giocare

- Indirizzo server: `localhost` (o IP macchina server)
- Porta: `5000`
- Il primo giocatore è X, il secondo è O
- Clicca sulle celle per piazzare il tuo simbolo
- Vinci allineando tre simboli!

## Griglia di gioco

```
[0] [1] [2]
[3] [4] [5]
[6] [7] [8]
```

## Protocollo TCP

Comunicazione JSON tra client e server per gestire mosse e stato del gioco.

## Autore

Damiano Duso
