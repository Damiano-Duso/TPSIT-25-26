# Remote Game - Tris Online

Applicazione mobile Flutter per giocare a Tris (Tic-Tac-Toe) a distanza tra due giocatori, con comunicazione via socket TCP.

## Architettura

```
remote_game/
├── server.dart                    # Server TCP
├── lib/
│   ├── main.dart                 # Entry point
│   ├── models/game_model.dart     # Modello Tris
│   ├── services/game_service.dart # Servizio TCP
│   └── screens/
│       ├── connection_screen.dart # Connessione
│       └── game_screen.dart       # Gioco
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
