import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flame/game.dart';
import 'package:get_storage/get_storage.dart';
import 'shadow_touch_game.dart';

class ShadowTouchView extends StatelessWidget {
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final game = ShadowTouchGame();

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GameWidget(
              game: game,
              overlayBuilderMap: {
                'GameOver': (context, _) {
                  final survival = game.survivalTime.toStringAsFixed(1);
                  final highScore = (box.read('shadow_highscore') ?? 0.0).toStringAsFixed(1);
        
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('GAME OVER', style: Theme.of(context).textTheme.titleLarge),
                        SizedBox(height: 10),
                        Text('Survived: $survival sec', style: TextStyle(color: Colors.white)),
                        Text('High Score: $highScore sec', style: TextStyle(color: Colors.orangeAccent)),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => Get.off(() => ShadowTouchView()),
                          child: Text("RETRY"),
                        ),
                        ElevatedButton(
                          onPressed: () => Get.back(),
                          child: Text("HOME"),
                        ),
                      ],
                    ),
                  );
                },
                'HUD': (context, _) {
                  return Positioned(
                    top: 30,
                    right: 20,
                    child: Obx(() {
                      return Text(
                        '⏱ ${game.survivalTime.value.toStringAsFixed(1)}s',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }),
                  );
                },
              },
              initialActiveOverlays: const ['HUD'],
            ),
        
            Positioned(
              top: 30,
              left: 20,
              child: Text("Shadow Touch", style: Theme.of(context).textTheme.titleLarge),
            ),
          ],
        ),
      ),
    );
  }
}
