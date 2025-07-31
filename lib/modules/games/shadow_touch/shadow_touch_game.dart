import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ShadowTouchGame extends FlameGame with PanDetector, HasCollisionDetection {
  late CircleComponent player;
  final List<CircleComponent> shadows = [];
  final box = GetStorage();

  bool isTouching = false;
  bool hasStarted = false;
  Vector2? fingerPosition;
  final survivalTime = 0.toDouble().obs;

  late TimerComponent shadowTimer;
  late TimerComponent scoreTimer;

  @override
  Color backgroundColor() => const Color(0xFF222222); // Proper way in this Flame version

  @override
  Future<void> onLoad() async {
    player = CircleComponent(
      radius: 30,
      paint: Paint()
        ..shader = const RadialGradient(
          colors: [Colors.greenAccent, Colors.greenAccent],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: 30)),
      anchor: Anchor.center,
    );;

    shadowTimer = TimerComponent(
      period: 1,
      repeat: true,
      onTick: _moveShadows,
    );

    scoreTimer = TimerComponent(
      period: 0.1,
      repeat: true,
      onTick: () {
        if (hasStarted && isTouching) {
          survivalTime.value += 0.1;
        }
      },
    );

    add(player);
    addAll([shadowTimer, scoreTimer]);

    for (int i = 0; i < 2; i++) {
      final shadow = CircleComponent(
        radius: 40,
        paint: Paint()..color = Colors.black.withOpacity(0.6),
        position: _randomPosition(),
      );
      shadows.add(shadow);
      add(shadow);
    }
  }

  @override
  void onMount() {
    super.onMount();
    player.position = size / 2;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!hasStarted) return;

    if (!isTouching || fingerPosition == null) {
      _endGame();
      return;
    }

    player.position = fingerPosition!;

    for (final shadow in shadows) {
      if (shadow.toRect().overlaps(player.toRect())) {
        _endGame();
      }
    }
  }

  @override
  void onPanStart(DragStartInfo info) {
    isTouching = true;
    fingerPosition = info.eventPosition.global;

    if (!hasStarted) {
      hasStarted = true;
      shadowTimer.timer.start();
      scoreTimer.timer.start();
    }
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    fingerPosition = info.eventPosition.global;
  }

  @override
  void onPanEnd(DragEndInfo info) {
    isTouching = false;
  }

  Vector2 _randomPosition() {
    return Vector2(
      Random().nextDouble() * size.x,
      Random().nextDouble() * size.y,
    );
  }

  void _moveShadows() {
    for (var shadow in shadows) {
      final target = _randomPosition();
      shadow.add(
        MoveEffect.to(
          target,
          EffectController(duration: 1, curve: Curves.easeInOut),
        ),
      );
    }
  }

  void _endGame() {
    pauseEngine();

    final oldHigh = box.read('shadow_highscore') ?? 0.0;
    if (survivalTime.value > oldHigh) {
      box.write('shadow_highscore', survivalTime.value);
    }

    overlays.add('GameOver');
  }
}
