import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flame/game.dart';
import 'combat_game.dart';

class CombatView extends StatelessWidget {
  final CombatGame game = CombatGame();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GameWidget(
            game: game,
            overlayBuilderMap: {
              'GameOver': (ctx, _) => Center(
                child: Obx(() {
                  final result = game.gameOverResult.value;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        result == 'win' ? '🏆 VICTORY!' : '💀 DEFEATED!',
                        style: TextStyle(
                          fontSize: 32,
                          color: result == 'win' ? Colors.greenAccent : Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => Get.off(() => CombatView()),
                        child: const Text("RETRY"),
                      ),
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text("🏠 HOME"),
                      ),
                    ],
                  );
                }),
              ),
            },
          ),

          // Power bar
          Positioned(
            top: 30,
            left: 20,
            child: Obx(() => Row(
              children: [
                Container(
                  width: 120,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      FractionallySizedBox(
                        widthFactor: (game.power.value / 100).clamp(0.0, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${game.power.value.toInt()}',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            )),
          ),

          // Instructions
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Text(
              'Tap to charge ⚡ | Swipe to attack 🎯',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),

          Positioned(
            top: 60,
            right: 20,
            child: Obx(() => Text(
              'Wave ${game.wave.value}',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )),
          ),
        ],
      ),
    );
  }
}
