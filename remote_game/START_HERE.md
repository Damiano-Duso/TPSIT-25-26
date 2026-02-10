# 🎮 INIZIO VELOCE - 5 MINUTI

**Leggi questo file PRIMA di tutto!**

---

## 📖 Documenti Essenziali (IN ORDINE)

1. **📌 QUESTO FILE** (1 min) - Sei qui!
2. **[INSTALLAZIONE.md](INSTALLAZIONE.md)** (5 min) - Setup
3. **[QUICKSTART.md](QUICKSTART.md)** (5 min) - Guida rapida
4. **Esegui il codice** - Gioca!

**Tempo totale**: 11 minuti

---

## ⚡ Start in 3 Steps

### Step 1: Installa dipendenze (2 min)
```bash
cd remote_game
flutter pub get
```

### Step 2: Avvia server (Terminal 1)
```bash
dart server.dart
```
**Aspetta**: `Server avviato su porta 5000` ✓

### Step 3: Avvia client 2 volte (Terminal 2 & 3 o 2 emulatori)
```bash
flutter run
```
**Per 2 client**: Ripeti il comando su device diversi

**Connection**: 
- Server: `localhost`
- Port: `5000`

---

## 🎮 Come Giocare

| Azione | Risultato |
|--------|-----------|
| Player 1: X | Inizia sempre |
| Player 2: O | Aspetta e gioca |
| Click cella | Posiziona il simbolo |
| 3 in fila | Vinci! 🎉 |

---

## 🐛 Problemi Comuni

### ❌ "Connection refused"
```
→ Assicurati che server sia avviato
  dart server.dart
```

### ❌ "Port 5000 already in use"
```
→ Windows: netstat -ano | findstr :5000
→ Mac/Linux: lsof -ti:5000 | xargs kill -9
```

### ❌ "Flutter not found"
```
→ flutter --version
→ Aggiungi flutter al PATH
```

### ❌ Android Emulator non si connette
```
→ Usa 10.0.2.2 invece di localhost
```

---

## 📚 Documentazione Completa

| Documento | Usa quando... |
|-----------|--------------|
| **[INSTALLAZIONE.md](INSTALLAZIONE.md)** | Errori di setup |
| **[QUICKSTART.md](QUICKSTART.md)** | Vuoi guida rapida |
| **[README.md](README.md)** | Leggi durante sviluppo |
| **[ARCHITETTURA.md](ARCHITETTURA.md)** | Vuoi capire a fondo |
| **[PROTOCOLLO.md](PROTOCOLLO.md)** | Sviluppi client/server |
| **[DEPLOYMENT.md](DEPLOYMENT.md)** | Vuoi deployare |
| **[TODO.md](TODO.md)** | Cerchi feature da aggiungere |
| **[BEST_PRACTICES.md](BEST_PRACTICES.md)** | Scrivi nuovo codice |
| **[INDICE.md](INDICE.md)** | Cerchi un documento |
| **[FILE_MAP.md](FILE_MAP.md)** | Vuoi mappa file |

---

## 🧪 Testing (Opzionale)

Test rapido della connessione:
```bash
dart test_client.dart
```

Test completo (due client che giocano):
```bash
dart test_integration.dart
```

---

## ✅ Checklist Primo Avvio

- [ ] Leggi questo file (1 min)
- [ ] Leggi INSTALLAZIONE.md (5 min)
- [ ] flutter pub get (2 min)
- [ ] Avvia server (Terminal 1)
- [ ] Avvia client 1 (Terminal 2)
- [ ] Avvia client 2 (Terminal 3 o device diverso)
- [ ] Connetti a localhost:5000
- [ ] Gioca una partita!

**Tempo totale**: ~15 minuti

---

## 🎯 Prossimi Passi

### Dopo che funziona:
1. Leggi [README.md](README.md)
2. Leggi [ARCHITETTURA.md](ARCHITETTURA.md)
3. Modifica colori
4. Aggiungi una feature da [TODO.md](TODO.md)

### Per capire il codice:
1. Apri [lib/main.dart](lib/main.dart)
2. Apri [server.dart](server.dart)
3. Apri [lib/screens/game_screen.dart](lib/screens/game_screen.dart)
4. Leggi i commenti

### Per deployare:
1. Leggi [DEPLOYMENT.md](DEPLOYMENT.md)
2. Scegli un ambiente
3. Segui le istruzioni

---

## 💡 Pro Tips

```bash
# Durante flutter run:
R       → Hot reload (mantiene stato)
Shift+R → Hot restart (reset)
q       → Quit

# Comandi utili:
flutter analyze      # Check for errors
flutter format lib/  # Format code
flutter clean        # Clean cache
flutter doctor       # Check setup
```

---

## 🎉 Pronto?

### Non hai fretta?
1. Leggi [INSTALLAZIONE.md](INSTALLAZIONE.md)
2. Leggi [QUICKSTART.md](QUICKSTART.md)
3. Esegui il codice

### Hai fretta?
1. `cd remote_game`
2. `flutter pub get`
3. `dart server.dart` (Terminal 1)
4. `flutter run` (Terminal 2 & 3)
5. Connetti a localhost:5000

### Sei un esperti?
Salta direttamente ai file sorgenti:
- [server.dart](server.dart)
- [lib/screens/game_screen.dart](lib/screens/game_screen.dart)
- [lib/services/game_service.dart](lib/services/game_service.dart)

---

## 📞 Aiuto Rapido

| Domanda | Risposta |
|---------|----------|
| Come avvio? | Vedi [INSTALLAZIONE.md](INSTALLAZIONE.md) |
| Come gioco? | Vedi [QUICKSTART.md](QUICKSTART.md) |
| Come modifico? | Vedi [BEST_PRACTICES.md](BEST_PRACTICES.md) |
| Come aggiungo feature? | Vedi [TODO.md](TODO.md) |
| Come capisco il codice? | Vedi [ARCHITETTURA.md](ARCHITETTURA.md) |
| Ho un errore | Vedi [INSTALLAZIONE.md](INSTALLAZIONE.md) troubleshooting |

---

## 🚀 Fatto Tutto?

```
✅ Hai avviato il server?
✅ Hai avviato 2 client?
✅ Hai giocato una partita?
✅ Hai visto il rilevamento della vittoria?

SE SÌ A TUTTO:
    → Complimenti! Il progetto funziona! 🎉
    
PROSSIMI PASSI:
    1. Leggi ARCHITETTURA.md
    2. Modifica il codice
    3. Aggiungi feature
    4. Divertiti!
```

---

**Non hai tempo?** Salta a [INSTALLAZIONE.md](INSTALLAZIONE.md) - ci sono comandi copy-paste!

**Leggi tutto?** Continua con [README.md](README.md)

**Vuoi codificare?** Vai a [lib/main.dart](lib/main.dart)

---

🎮 **Buon gioco!**
