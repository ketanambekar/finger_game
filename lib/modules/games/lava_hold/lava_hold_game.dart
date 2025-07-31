// lava_hold_game.dart
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LavaHoldGame extends FlameGame with TapDetector {
  final box = GetStorage();
  final int gridSize = 3;
  final double tileSize = 100;
  final List<LavaTile> tiles = [];
  late Player player;

  final survivalTime = 0.0.obs;
  late TimerComponent crackTimer;
  late TimerComponent scoreTimer;

  @override
  Color backgroundColor() => const Color(0xFF1a1a1a);

  @override
  Future<void> onLoad() async {
    final double padding = 20;
    final startX = (size.x - (gridSize * tileSize + (gridSize - 1) * padding)) / 2;
    final startY = (size.y - (gridSize * tileSize + (gridSize - 1) * padding)) / 2;

    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        final tile = LavaTile(
          position: Vector2(startX + col * (tileSize + padding), startY + row * (tileSize + padding)),
          size: Vector2(tileSize, tileSize),
        );
        tiles.add(tile);
        add(tile);
      }
    }

    final centerTile = tiles[(gridSize * gridSize) ~/ 2];
    player = Player(position: centerTile.center - Vector2(15, 15));
    add(player);

    crackTimer = TimerComponent(
      period: 2,
      repeat: true,
      onTick: _crackRandomTile,
    );
    scoreTimer = TimerComponent(
      period: 0.1,
      repeat: true,
      onTick: () => survivalTime.value += 0.1,
    );

    addAll([crackTimer, scoreTimer]);
  }

  void _crackRandomTile() {
    final candidates = tiles.where((t) => !t.isGone && !t.isCracking).toList();
    if (candidates.isEmpty) return;

    final chosen = candidates[Random().nextInt(candidates.length)];
    chosen.startCracking(() {
      if (player.toRect().overlaps(chosen.toRect())) {
        _endGame();
      }
    });
  }

  @override
  void onTapDown(TapDownInfo info) {
    final targetTile = tiles.firstWhereOrNull((tile) =>
    tile.toRect().contains(info.eventPosition.global.toOffset()) &&
        !tile.isGone);

    if (targetTile != null) {
      player.jumpTo(targetTile.center - Vector2(15, 15));
    }
  }

  void _endGame() {
    pauseEngine();
    final oldHigh = box.read('lava_highscore') ?? 0.0;
    if (survivalTime.value > oldHigh) {
      box.write('lava_highscore', survivalTime.value);
    }
    overlays.add('GameOver');
  }
}

class Player extends PositionComponent with HasGameRef<LavaHoldGame> {
  Player({required Vector2 position}) : super(position: position, size: Vector2(30, 30));

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.deepOrange;
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), 15, paint);
  }

  void jumpTo(Vector2 newPos) {
    position = newPos;
  }
}

class LavaTile extends PositionComponent with HasGameRef<LavaHoldGame> {
  bool isCracking = false;
  bool isGone = false;

  LavaTile({required Vector2 position, required Vector2 size})
      : super(position: position, size: size);

  void startCracking(VoidCallback onBreak) {
    isCracking = true;
    Future.delayed(Duration(seconds: 1), () {
      isGone = true;
      isCracking = false;
      onBreak();
    });
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = isGone
          ? Colors.transparent
          : isCracking
          ? Colors.red.withOpacity(0.7)
          : Colors.grey[800]!;
    canvas.drawRect(size.toRect(), paint);
  }
}
