# TODO e Known Issues

## ✅ Completato

- [x] Server TCP di base
- [x] Client Flutter con connessione
- [x] Schermata di connessione
- [x] Schermata di gioco
- [x] Griglia 3x3 interattiva
- [x] Logica di validazione mosse
- [x] Rilevamento vittoria
- [x] Gestione turni
- [x] Messaggi di stato
- [x] Gestione disconnessione
- [x] Protocollo JSON
- [x] Documentazione

---

## 📋 TODO - Miglioramenti Futuri

### Gameplay
- [ ] Supporto per multiple partite simultanee
- [ ] Sistema di rating ELO
- [ ] Cronometro per turno
- [ ] Undo della mossa (last move only)
- [ ] Replay della partita
- [ ] Salvataggio statistiche

### Interfaccia
- [ ] Tema scuro
- [ ] Animazioni movimento
- [ ] Sound effects
- [ ] Notifiche push
- [ ] Lobby con lista di giocatori
- [ ] Avatar personalizzati
- [ ] Nickname dei giocatori

### Rete
- [ ] Auto-reconnect se disconnesso
- [ ] Keep-alive heartbeat
- [ ] Compressione JSON
- [ ] WebSocket support
- [ ] IPv6 support

### Sicurezza
- [ ] SSL/TLS encryption
- [ ] Autenticazione utenti
- [ ] Rate limiting
- [ ] Validazione input rigorosa
- [ ] Protezione contro DDoS
- [ ] Token di sessione

### Giochi Aggiuntivi
- [ ] Forza 4 (7x6)
- [ ] Battaglia Navale
- [ ] Gioco del 2048
- [ ] Domino
- [ ] Morra Cinese

### Backend
- [ ] Database persistente
- [ ] API REST
- [ ] Account system
- [ ] Leaderboard
- [ ] Chat tra giocatori
- [ ] Friend list
- [ ] Inviti personalizzati

### Testing
- [ ] Unit tests per logica gioco
- [ ] Widget tests per UI
- [ ] Integration tests completi
- [ ] Load testing server
- [ ] Test su dispositivi reali
- [ ] Test di latenza

### DevOps
- [ ] Docker container per server
- [ ] CI/CD pipeline
- [ ] Auto-deployment
- [ ] Monitoring e alerting
- [ ] Backup automatico
- [ ] Scaling automatico

---

## 🐛 Known Issues

### Server
- [ ] **Memory leak** se client si disconnette durante la partita
  - Workaround: Riavvia il server periodicamente
  - Fix: Implementare proper cleanup in onDone handler

- [ ] **Race condition** se due client inviano mosse simultaneamente
  - Workaround: Il server accetta sempre il primo messaggio
  - Fix: Implementare mutex/lock per accesso thread-safe

- [ ] **Timeout non gestito** se client si blocca senza disconnettere
  - Workaround: Nessuno attualmente
  - Fix: Implementare read timeout sulla socket

### Client Flutter
- [ ] **UI freeze** durante connessione lenta
  - Workaround: Aumentare il timeout
  - Fix: Mostrare indicatore di caricamento animato

- [ ] **Back button non disabilita la griglia** se il gioco è finito
  - Workaround: Click su "Esci dal gioco" prima
  - Fix: Disabilitare interazioni dopo gameOver

- [ ] **Double-tap bug** su celle della griglia
  - Workaround: Attendere la risposta del server
  - Fix: Disabilitare interazioni durante l'invio della mossa

- [ ] **Emulatore Android 10.0.2.2** non si connette a localhost
  - Workaround: Usare l'IP reale della macchina host
  - Fix: Aggiungere opzione di auto-detect

### Rete
- [ ] **Perdita di messaggi** se la connessione è instabile
  - Workaround: Riconnettersi
  - Fix: Implementare ACK e retry logic

- [ ] **Latenza alta** su reti slow
  - Workaround: Nessuno
  - Fix: Comprimere JSON, ridurre frequenza aggiornamenti

---

## ⚠️ Limitazioni Conosciute

1. **Una sola partita per cliente** 
   - Impossibile giocare più partite simultanee
   - Soluzione: Modificare GameService per supportare multi-game

2. **No persistenza dei dati**
   - Le partite non vengono salvate
   - Soluzione: Aggiungere database

3. **No autenticazione**
   - Qualsiasi client può connettarsi
   - Soluzione: Implementare token/password

4. **Niente chat**
   - I giocatori non possono comunicare
   - Soluzione: Aggiungere chat protocol

5. **Niente statistiche**
   - Non viene tracciato chi ha vinto/perso
   - Soluzione: Database + leaderboard

6. **Server single-threaded per connessioni**
   - Può gestire solo ~100 partite simultanee
   - Soluzione: Multi-threading avanzato

7. **No recovery da crash server**
   - Se il server si arresta, i client vedono errore
   - Soluzione: Graceful shutdown + client auto-reconnect

8. **Griglia fissa 3x3**
   - Non è possibile scegliere la dimensione
   - Soluzione: Parametrizzare la dimensione

---

## 🔍 Debug Checklist

Prima di reportare un issue:

- [ ] Verificare che il server sia realmente avviato
- [ ] Controllare l'indirizzo IP del server
- [ ] Verificare la porta (5000 per default)
- [ ] Controllare il firewall
- [ ] Verificare i log del server
- [ ] Verificare i log del client (Debug Console)
- [ ] Provare a riavviare sia client che server
- [ ] Verificare la versione di Dart/Flutter
- [ ] Testare con localhost prima che con IP esterno
- [ ] Usare lo script test_client.dart o test_integration.dart

---

## 📝 Come Reportare un Issue

Usare il formato seguente:

```
TITOLO: [Area] Descrizione breve

DESCRIZIONE:
- Cosa stavi facendo
- Cosa ti aspettavi
- Cosa è successo invece

PASSI PER RIPRODURRE:
1. ...
2. ...
3. ...

AMBIENTE:
- OS: Windows/Mac/Linux
- Dart version: X.X.X
- Flutter version: X.X.X
- Dispositivo: Emulatore/Reale

SCREENSHOT/LOG:
[Se applicabile]
```

---

## 📞 Contatti

Per domande o suggerimenti:
- Progetto educativo TPSIT 2025-26

---

## Versione

- **Version**: 1.0.0
- **Status**: Beta
- **Last Updated**: Febbraio 2026
