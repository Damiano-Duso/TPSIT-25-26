# Tris Online

Applicazione mobile Flutter per giocare a Tris (Tic-Tac-Toe) a distanza tra due giocatori, con comunicazione via socket TCP.

## Architettura

```
tris/
├── server.dart                    # Server TCP per gestire le connessioni
├── lib/
│   ├── main.dart                 # Punto di ingresso dell'applicazione
│   ├── models/game_model.dart     # Modello di dati per il gioco del Tris
│   ├── services/game_service.dart # Servizio per la comunicazione TCP
│   └── screens/
│       ├── connection_screen.dart # Schermata per inserire indirizzo e porta del server
│       └── game_screen.dart       # Schermata principale del gioco
└── pubspec.yaml
```

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


## Damiano Duso