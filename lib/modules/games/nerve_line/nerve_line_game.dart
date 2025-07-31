// lib/modules/games/nerve_line/nerve_line_game.dart

import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class NerveLineGame extends FlameGame with PanDetector {
  final box = GetStorage();
  final survivalTime = 0.0.obs;
  late TimerComponent scoreTimer;

  late PlayerDot player;
  final List<PathZone> zones = [];

  bool isTouching = false;
  Vector2? fingerPosition;

  @override
  Color backgroundColor() => const Color(0xFF111111);

  @override
  Future<void> onLoad() async {
    player = PlayerDot();
    add(player);

    _generateZones();

    scoreTimer = TimerComponent(
      period: 0.1,
      repeat: true,
      onTick: () {
        if (isTouching) survivalTime.value += 0.1;
      },
    );
    add(scoreTimer);
  }

  void _generateZones() {
    final zoneHeight = 100.0;
    for (int i = 0; i < 10; i++) {
      final y = size.y - (i * zoneHeight);
      final xOffset = Random().nextDouble() * (size.x - 120);

      final zone = PathZone(position: Vector2(xOffset, y), size: Vector2(120, zoneHeight));
      zones.add(zone);
      add(zone);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!isTouching || fingerPosition == null) return;

    player.position = fingerPosition! - Vector2.all(player.size.x / 2);

    final withinZone = zones.any((z) => z.toRect().contains(player.toRect().center));
    if (!withinZone) {
      _endGame();
    }

    for (final z in zones) {
      z.position.y += 30 * dt; // scroll speed
    }

    // Add new zones
    if (zones.last.position.y > 0) {
      final y = zones.last.position.y - 100;
      final xOffset = Random().nextDouble() * (size.x - 120);
      final zone = PathZone(position: Vector2(xOffset, y), size: Vector2(120, 100));
      zones.add(zone);
      add(zone);
    }

    // Remove old
    zones.removeWhere((z) => z.position.y > size.y + 100);
  }

  @override
  void onPanStart(DragStartInfo info) {
    isTouching = true;
    fingerPosition = info.eventPosition.global;
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    fingerPosition = info.eventPosition.global;
  }

  @override
  void onPanEnd(DragEndInfo info) {
    isTouching = false;
    _endGame();
  }

  void _endGame() {
    pauseEngine();
    final old = box.read('nerve_highscore') ?? 0.0;
    if (survivalTime.value > old) {
      box.write('nerve_highscore', survivalTime.value);
    }
    overlays.add('GameOver');
  }
}

class PlayerDot extends PositionComponent {
  PlayerDot() : super(size: Vector2.all(30));

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.cyanAccent;
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, paint);
  }
}

class PathZone extends PositionComponent {
  PathZone({required super.position, required super.size});

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.deepPurple.withOpacity(0.5)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(size.toRect(), Radius.circular(12)),
      paint,
    );
  }
}