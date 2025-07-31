import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flame/game.dart';
import 'package:get_storage/get_storage.dart';
import 'nerve_line_game.dart';

class NerveLineView extends StatelessWidget {
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final game = NerveLineGame();

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GameWidget(
              game: game,
              overlayBuilderMap: {
                'GameOver': (context, _) {
                  final survived = game.survivalTime.value.toStringAsFixed(1);
                  final best = (box.read('nerve_highscore') ?? 0.0).toStringAsFixed(1);

                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '⚡ GAME OVER ⚡',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.purpleAccent,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Survived: $survived s',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          'High Score: $best s',
                          style: TextStyle(color: Colors.amber, fontSize: 16),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => Get.off(() => NerveLineView()),
                          child: Text("RETRY"),
                        ),
                        SizedBox(height: 10),
                        TextButton(
                          onPressed: () => Get.back(),
                          child: Text("🏠 HOME"),
                        ),
                      ],
                    ),
                  );
                },
              },
            ),
            Positioned(
              top: 20,
              left: 20,
              child: Obx(() => Text(
                'Time: ${game.survivalTime.value.toStringAsFixed(1)}',
                style: TextStyle(color: Colors.white, fontSize: 18),
              )),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: Text(
                'NERVE LINE',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.pinkAccent,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
