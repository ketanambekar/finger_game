// lib/modules/games/splat_escape/splat_escape_game.dart
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplatEscapeGame extends FlameGame with TapDetector {
  final survivalTime = 0.0.obs;
  final box = GetStorage();
  late Player player;
  final List<SplatObstacle> obstacles = [];

  late TimerComponent obstacleSpawner;
  late TimerComponent scoreTimer;

  @override
  Color backgroundColor() => const Color(0xFF111111);

  @override
  Future<void> onLoad() async {
    player = Player(position: size / 2);
    add(player);

    obstacleSpawner = TimerComponent(
      period: 1.2,
      repeat: true,
      onTick: _spawnObstacle,
    );

    scoreTimer = TimerComponent(
      period: 0.1,
      repeat: true,
      onTick: () => survivalTime.value += 0.1,
    );

    addAll([obstacleSpawner, scoreTimer]);
  }

  void _spawnObstacle() {
    final x = Random().nextDouble() * size.x;
    final obstacle = SplatObstacle(position: Vector2(x, -20));
    obstacles.add(obstacle);
    add(obstacle);
  }

  @override
  void update(double dt) {
    super.update(dt);

    for (final obs in obstacles) {
      if (obs.toRect().overlaps(player.toRect())) {
        _endGame();
        break;
      }
    }
  }

  @override
  void onTapDown(TapDownInfo info) {
    final touch = info.eventPosition.global;
    player.dashToward(touch);
  }

  void _endGame() {
    pauseEngine();
    final oldHigh = box.read('splat_highscore') ?? 0.0;
    if (survivalTime.value > oldHigh) {
      box.write('splat_highscore', survivalTime.value);
    }
    overlays.add('GameOver');
  }
}

class Player extends PositionComponent {
  Player({required Vector2 position})
      : super(position: position, size: Vector2.all(30));

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.cyanAccent;
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), 15, paint);
  }

  void dashToward(Vector2 target) {
    final direction = (target - position).normalized();
    position += direction * 60;
  }
}

class SplatObstacle extends PositionComponent {
  SplatObstacle({required Vector2 position})
      : super(position: position, size: Vector2(30, 30));

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.redAccent;
    canvas.drawOval(size.toRect(), paint);
  }

  @override
  void update(double dt) {
    position += Vector2(0, 100 * dt); // Falls downward
    super.update(dt);
  }
}