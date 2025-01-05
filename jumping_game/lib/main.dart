import 'package:flutter/material.dart';
import 'dart:async';
import 'backend_file.dart';

void main() {
  runApp(const ImpossibleGame());
}

class ImpossibleGame extends StatelessWidget {
  const ImpossibleGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  double circleY = 0;
  double velocity = 0;
  final double gravity = 0.0015;
  final double jumpForce = -0.025;
  int score = 0;
  bool isGameOver = false;
  int highScore = 0;
  late Timer gameLoop;

  final BackendService backendService = BackendService('http://localhost');

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

          
          checkGameOver();
        }
      });
    });
  }

  void checkGameOver() {
    if (circleY > 1) { 
      handleGameOver();
    }
  }

  void handleGameOver() async {
    isGameOver = true;
    gameLoop.cancel(); 
    await saveHighScore(score); 
    highScore = await backendService.getHighScore();
    setState(() {});
  }

  Future<void> saveHighScore(int score) async {
    try {
      await backendService.saveHighScore(score);
    } catch (error) {
      print("Failed to save high score: $error");
    }
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
                      "Your Score: $score",
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "High Score: $highScore",
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
