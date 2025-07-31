import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flame/game.dart';
import 'package:get_storage/get_storage.dart';
import 'spider_flick_game.dart';

class SpiderFlickView extends StatelessWidget {
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final game = SpiderFlickGame();

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GameWidget(
              game: game,
              overlayBuilderMap: {
                'GameOver': (context, _) {
                  final survived = game.survivalTime.value.toStringAsFixed(1);
                  final best = (box.read('spider_highscore') ?? 0.0).toStringAsFixed(1);

                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('🕷️ YOU GOT BITTEN! 🕷️',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                            )),
                        SizedBox(height: 10),
                        Text('Survived: $survived s', style: TextStyle(color: Colors.white, fontSize: 16)),
                        Text('High Score: $best s', style: TextStyle(color: Colors.orangeAccent, fontSize: 16)),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => Get.off(() => SpiderFlickView()),
                          child: Text("RETRY"),
                        ),
                        TextButton(
                          onPressed: () => Get.back(),
                          child: Text("🏠 HOME"),
                        ),
                      ],
                    ),
                  );
                }
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
                'SPIDER FLICK',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.greenAccent,
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
