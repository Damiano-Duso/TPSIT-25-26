# 📋 Checklist di Installazione e Avvio

## ✅ Pre-requisiti Installati

- [x] Dart SDK (versione 3.10.4+)
- [x] Flutter SDK
- [x] Git (opzionale)
- [x] Editor: VS Code o Android Studio

## 📦 Setup del Progetto

### Step 1: Dipendenze Flutter
```bash
cd remote_game
flutter pub get
```
**Output atteso**: "Got dependencies!"

### Step 2: Verificare l'Installazione
```bash
flutter doctor
flutter --version
dart --version
```

### Step 3: Preparare il Device
```bash
# Per emulator Android
flutter emulators --launch <nome_emulator>

# Per dispositivo reale
flutter devices
```

---

## 🎮 Avvio dell'Applicazione

### Passo 1: Avviare il Server (Terminal 1)
```bash
cd remote_game
dart server.dart
```

**Attendi**: `Server avviato su porta 5000`

---

### Passo 2: Avviare Client 1 (Terminal 2)
```bash
cd remote_game
flutter run
```

**Schermata**: Vedrai "Benvenuto al Tris Online!"

**Input**:
- Server: `localhost`
- Porta: `5000`
- Click: "Connetti al Server"

**Attendi**: "In attesa di un avversario..."

---

### Passo 3: Avviare Client 2 (Terminal 3 o nuovo emulator)
```bash
cd remote_game
flutter run
```

**Ripeti**: Stessi step di Passo 2

**Risultato**: Il gioco inizia! 🎉

---

## 🕹️ Come Giocare

| Azione | Risultato |
|--------|-----------|
| Client 1 (X) inizia | Giocatore 1 è X |
| Client 2 (O) aspetta | Giocatore 2 è O |
| Click su cella vuota | Posiziona il tuo simbolo |
| Allinea 3 simboli | Vinci! 🎉 |
| Griglia piena | Pareggio 🤝 |

---

## 🧪 Testing (Opzionale)

### Test 1: Client Dart
```bash
cd remote_game
dart test_client.dart
```

**Output atteso**:
- ✓ Connesso al server
- ✓ Messaggio inviato
- ✓ Risposta ricevuta

### Test 2: Integrazione Completa
```bash
cd remote_game
dart test_integration.dart
```

**Output atteso**:
- ✓ Player 1 connesso
- ✓ Player 2 connesso
- ✓ Game started
- ✓ Mosse eseguite
- ✓ Vincitore rilevato

---

## 🐛 Troubleshooting

### ❌ "Connection refused"
```
Causa: Server non avviato
Soluzione: 
  1. Apri Terminal 1
  2. Esegui: dart server.dart
  3. Attendi: "Server avviato su porta 5000"
```

### ❌ "Port 5000 already in use"
```
Causa: Porta occupata
Soluzione (Windows):
  1. netstat -ano | findstr :5000
  2. taskkill /PID <PID> /F
Soluzione (Mac/Linux):
  1. lsof -ti:5000 | xargs kill -9
```

### ❌ Android Emulator non si connette
```
Causa: Localhost non raggiungibile
Soluzione:
  Server: 10.0.2.2 (non localhost)
  Porta: 5000
```

### ❌ "Flutter not found"
```
Causa: Flutter non nel PATH
Soluzione:
  1. Controlla: flutter --version
  2. Aggiungi flutter al PATH
  3. Riavvia terminal
```

### ❌ App si blocca al caricamento
```
Causa: Server non risponde
Soluzione:
  1. Verifica server sia avviato
  2. Verifica indirizzo IP/Porta
  3. Prova con localhost su stesso computer
  4. Controlla firewall
```

---

## 📚 Documentazione

Dopo l'avvio, consulta:

1. [README.md](README.md) - Documentazione principale
2. [QUICKSTART.md](QUICKSTART.md) - Guida rapida
3. [PROTOCOLLO.md](PROTOCOLLO.md) - Protocollo di comunicazione
4. [ARCHITETTURA.md](ARCHITETTURA.md) - Dettagli tecnici
5. [DEPLOYMENT.md](DEPLOYMENT.md) - Deployment e configurazione
6. [TODO.md](TODO.md) - Roadmap e miglioramenti
7. [BEST_PRACTICES.md](BEST_PRACTICES.md) - Standard di coding
8. [RIEPILOGO.md](RIEPILOGO.md) - Sommario completo

---

## 🚀 Prossimi Passi

### Fase 1: Personalizzazione
- [ ] Cambia colori nel tema
- [ ] Modifica i messaggi
- [ ] Personalizza l'icona
- [ ] Cambia nome app

### Fase 2: Funzionalità
- [ ] Aggiungi score tracker
- [ ] Implementa undo mossa
- [ ] Aggiungi timer turno
- [ ] Sistema di statistiche

### Fase 3: Nuovi Giochi
- [ ] Forza 4 (7x6)
- [ ] Battaglia Navale
- [ ] Dadi/Carte

### Fase 4: Deployment
- [ ] Build APK/IPA
- [ ] Publish su Play Store
- [ ] Deploy server production
- [ ] Aggiungi database

---

## 💡 Tips Utili

### Sviluppo Rapido
```bash
# Hot reload (mantiene stato)
R key durante flutter run

# Hot restart (reset app)
Shift+R key durante flutter run

# Rebuild UI
Ctrl+\ durante flutter run
```

### Debugging
```bash
# Abilita debug prints
flutter run --verbose

# Apri Flutter DevTools
flutter pub global activate devtools
flutter devtools

# Leggi logs
flutter logs
```

### Performance
```bash
# Profiling
flutter run --profile

# Release build (più veloce)
flutter run --release
```

---

## 📋 Checklist Finale

Prima di dichiarare completo:

- [ ] Server avvia senza errori
- [ ] Client 1 si connette
- [ ] Client 2 si connette
- [ ] Gioco inizia
- [ ] Mosse funzionano
- [ ] Vittoria rilevata
- [ ] Pareggio rilevato
- [ ] Disconnessione gestita
- [ ] Documentazione consultabile

---

## 🎓 Learning Outcomes

Complimenti! Hai imparato:

✓ Socket Programming TCP in Dart
✓ Comunicazione JSON su rete
✓ Sviluppo mobile con Flutter
✓ State management e UI
✓ Logica di gioco
✓ Testing e debugging
✓ Documentazione tecnica
✓ Best practices di coding

---

## 📞 Supporto

Per problemi:

1. Consulta [TODO.md](TODO.md) per known issues
2. Guarda [TROUBLESHOOTING](DEPLOYMENT.md#troubleshooting-di-deployment)
3. Controlla [BEST_PRACTICES.md](BEST_PRACTICES.md) per errori comuni
4. Esegui test: `dart test_client.dart`

---

## 🎉 Buon Divertimento!

Sei pronto a giocare a Tris online! 🎮

**Ricorda**: Questo è un progetto educativo. Sentiti libero di:
- Modificare il codice
- Aggiungere feature
- Experimentare con rete
- Imparare dai sorgenti

**Progetto educativo TPSIT 2025-26**

```
  _________
 / ___   __\
| | X | O  |
|_|___|___|
  | X |_   |
  |___|_|  |
    | O | X|
    |___|___|
    
    X vince! 🎉
```
