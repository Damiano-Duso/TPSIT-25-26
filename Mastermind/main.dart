import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MaterialApp(
    title: 'Mastermind',
    home: MastermindGame(),
  ));
}

class Attempt {
  List<int> guess;
  int exact;
  int present;

  Attempt(this.guess, this.exact, this.present);
}

class MastermindGame extends StatefulWidget {
  @override
  State<MastermindGame> createState() => _MastermindGameState();
}

class _MastermindGameState extends State<MastermindGame> {
  final colors = [Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.purple, Colors.pink];
  List<int> secret = [], guess = [0, 0, 0, 0];
  List<Attempt> history = [];
  bool won = false;

  @override
  void initState() {
    super.initState();
    newGame();
  }

  void newGame() => setState(() {
    secret = List.generate(4, (_) => Random().nextInt(colors.length));
    guess = [0, 0, 0, 0];
    history = [];
    won = false;
  });

  void check() {
    if (won) return;
    var s = [...secret], g = [...guess];
    int exact = 0, present = 0;
    
    for (int i = 0; i < 4; i++) {
      if (g[i] == s[i]) {
        exact++;
        s[i] = g[i] = -1;
      }
    }
    
    for (int i = 0; i < 4; i++) {
      if (g[i] >= 0) {
        int idx = s.indexOf(g[i]);
        if (idx != -1) {
          present++;
          s[idx] = -1;
        }
      }
    }

    setState(() {
      history.add(Attempt([...guess], exact, present));
      won = exact == 4;
      if (!won) guess = [0, 0, 0, 0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[800],
      body: Center(
        child: Container(
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          constraints: BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Mastermind', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.purple)),
              SizedBox(height: 8),
              Text('Tentativi: ${history.length}', style: TextStyle(color: Colors.grey)),
              SizedBox(height: 16),
              
              if (won) Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(color: Colors.green[100], border: Border.all(color: Colors.green, width: 2), borderRadius: BorderRadius.circular(8)),
                child: Text('Hai vinto in ${history.length} tentativi!', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ),

              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (i) => GestureDetector(
                        onTap: won ? null : () => setState(() => guess[i] = (guess[i] + 1) % colors.length),
                        child: Container(
                          width: 64, height: 64,
                          decoration: BoxDecoration(
                            color: won ? colors[guess[i]] : (guess[i] == 0 ? Colors.grey : colors[guess[i]]),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey[400]!, width: 4),
                          ),
                        ),
                      )),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: won ? null : check,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, disabledBackgroundColor: Colors.grey, padding: EdgeInsets.symmetric(vertical: 16)),
                        child: Text('Verifica', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
              
              if (history.isNotEmpty) ...[
                SizedBox(height: 16),
                Align(alignment: Alignment.centerLeft, child: Text('Tentativi precedenti', style: TextStyle(fontWeight: FontWeight.bold))),
                SizedBox(height: 8),
                Container(
                  constraints: BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      var attempt = history[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 8),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: List.generate(4, (i) => Container(
                              width: 32, height: 32,
                              margin: EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(color: colors[attempt.guess[i]], shape: BoxShape.circle, border: Border.all(color: Colors.grey[400]!, width: 2)),
                            ))),
                            Row(children: [
                              Container(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.green[200], borderRadius: BorderRadius.circular(4)), child: Text('Esatti: ${attempt.exact}', style: TextStyle(fontSize: 12))),
                              SizedBox(width: 8),
                              Container(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.yellow[200], borderRadius: BorderRadius.circular(4)), child: Text('Presenti: ${attempt.present}', style: TextStyle(fontSize: 12))),
                            ]),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
              
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: newGame,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.purple[600], padding: EdgeInsets.symmetric(vertical: 16)),
                  child: Text('Nuova Partita', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}