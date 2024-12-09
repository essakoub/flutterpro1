import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const ImpossibleGame());
}

class ImpossibleGame extends StatelessWidget {
  const ImpossibleGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  double circleY = 0; 
  double velocity = 0; 
  double gravity = 0.0015; // gravity applied on the ball while falling
  double jumpForce = -0.025; // how much force it goes up when clicked on ball 
  int score = 0;
  bool isGameOver = false; 
  late Timer gameLoop;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    setState(() {
      circleY = 0;
      velocity = 0;
      score = 0;
      isGameOver = false;
    });

    gameLoop = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      setState(() {
        if (isGameOver) {
          timer.cancel();
        } else {
          velocity += gravity;
          circleY += velocity;

          if (circleY > 1) {
            isGameOver = true;
            gameLoop.cancel();
          }
        }
      });
    });
  }

  void jump() {
    if (!isGameOver) {
      setState(() {
        velocity = jumpForce;
        score++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 17, 204, 32),
      body: GestureDetector(
        onTap: jump,
        child: Stack(
          children: [
          
            Align(
              alignment: Alignment(0, circleY),
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            
            Positioned(
              top: 50,
              left: 20,
              child: Text(
                "Score: $score",
                style: const TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
            
            if (isGameOver)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Game Over!",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      "Your Last Score: $score",
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: startGame,
                      child: const Text("Restart"),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    gameLoop.cancel();
    super.dispose();
  }
}