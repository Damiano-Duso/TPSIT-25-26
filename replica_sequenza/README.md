2# Replica Sequenza

Progetto scolastico realizzato in Flutter che utilizza il sensore accelerometro del dispositivo per creare un gioco di memoria gestuale ispirato al classico Simon Says.

---

## Descrizione

L'app genera una sequenza casuale di gesti fisici da replicare con il telefono. Ad ogni round superato, la sequenza si allunga di un gesto. L'obiettivo è arrivare il più lontano possibile senza sbagliarne uno.

---

## File del progetto

- `lib/main.dart`: Punto di ingresso dell'applicazione, configura il tema e avvia la schermata iniziale.
- `lib/screens/home_screen.dart`: Schermata iniziale con il logo, descrizione del gioco e pulsante per iniziare.
- `lib/screens/game_screen.dart`: Schermata principale del gioco dove si visualizza la sequenza e si interagisce.
- `lib/models/game_controller.dart`: Logica di controllo del gioco, gestione della sequenza e fasi.
- `lib/models/gesture_type.dart`: Definizioni dei tipi di gesti riconosciuti.
- `lib/widgets/gesture_card.dart`: Widget per rappresentare un singolo gesto nella sequenza.
- `lib/widgets/sequence_preview.dart`: Widget per mostrare l'anteprima della sequenza.
- `lib/widgets/status_header.dart`: Widget per mostrare lo stato del gioco (punteggio, fase).
- `lib/services/`: Directory per i servizi, come la gestione dei sensori.

---

## Gesti riconosciuti

| Gesto            | Movimento richiesto                  |
|------------------|--------------------------------------|
| Inclina destra   | Ruotare il telefono verso destra     |
| Inclina sinistra | Ruotare il telefono verso sinistra   |
| Inclina avanti   | Inclinare il telefono in avanti      |
| Scuoti           | Agitare rapidamente il telefono      |

---

## Come funziona il codice

**Lettura dell'accelerometro**

Il file `accelerometer_service.dart` si sottoscrive allo stream di eventi del sensore tramite la libreria `sensors_plus`. Ad ogni campione ricevuto, vengono letti i valori di accelerazione sui tre assi (x, y, z) espressi in m/s².

**Rilevamento dei gesti**

I gesti di inclinazione vengono identificati confrontando i valori degli assi con delle soglie fisse:

```
Inclina destra   →  x > +5.5
Inclina sinistra →  x < -5.5
Inclina avanti   →  y < -6.0
```

Per lo shake si utilizza una sliding window di 5 campioni consecutivi. Ad ogni nuovo campione viene calcolata la magnitudine del vettore accelerazione e confrontata con la media della finestra; se la deviazione supera 22.0 m/s² il gesto viene registrato. Questo approccio evita falsi positivi causati da semplici inclinazioni brusche.

Un cooldown di 800 ms impedisce che lo stesso gesto venga registrato più volte di seguito.

**Logica di gioco**

Il `GameController` gestisce lo stato tramite `ChangeNotifier`. All'inizio di ogni round, aggiunge un gesto casuale alla sequenza e la mostra all'utente evidenziando un elemento alla volta con un ritardo di 900 ms. Terminata l'anteprima, il controller si mette in ascolto dei gesti rilevati dal sensore e li confronta in ordine con la sequenza attesa. Se tutti i gesti vengono replicati correttamente si passa al round successivo; al primo errore il gioco termina e viene mostrato il punteggio.


## Damiano Duso