import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CombatGame extends FlameGame with TapDetector, PanDetector {
  final power = 0.0.obs;
  final gameOverResult = ''.obs;
  final wave = 1.obs;

  bool hasAttacked = false;
  late Enemy enemy;
  late Player player;
  late TimerComponent powerDrain;

  @override
  Color backgroundColor() => const Color(0xFF0C0C1E);

  @override
  Future<void> onLoad() async {
    powerDrain = TimerComponent(
      period: 0.2,
      repeat: true,
      onTick: () {
        if (power.value > 0 && !hasAttacked) {
          power.value -= 1.5;
        }
      },
    );
    add(powerDrain);
  }

  @override
  void onMount() {
    super.onMount();
    player = Player(position: Vector2(size.x / 2 - 50, size.y - 140));
    add(player);
    spawnEnemy();
  }

  void spawnEnemy() {
    final baseHP = 80 + (wave.value * 30); // increases each wave
    enemy = Enemy(
      position: Vector2(size.x / 2 - 50, 140),
      maxHp: baseHP.toDouble(),
    );
    add(enemy);
    power.value = 0;
    hasAttacked = false;
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (!hasAttacked) {
      power.value += 5;
      if (power.value > 100) power.value = 100;
    }
  }

  @override
  void onPanEnd(DragEndInfo info) {
    if (power.value >= 50 && !hasAttacked && enemy.isAlive) {
      hasAttacked = true;
      player.attack();
      enemy.takeDamage(60);
      power.value = 0; // 🆕 Reset power after attack

      // Slash effect
      final effect = RectangleComponent(
        position: enemy.position - Vector2(10, 10),
        size: enemy.size + Vector2(20, 20),
        paint: Paint()..color = Colors.yellow.withOpacity(0.5),
      );
      add(effect);
      Future.delayed(const Duration(milliseconds: 200), () {
        effect.removeFromParent();
      });

      // Wait and check if enemy is dead
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!enemy.isAlive) {
          wave.value++;
          spawnEnemy();
        }
        hasAttacked = false; // 🆕 Allow attacking again
      });
    }
  }

  void _endGame({required bool win}) {
    gameOverResult.value = win ? 'win' : 'lose';
    overlays.add('GameOver');
    pauseEngine();
  }
}

// ─────────────────────────────────────────────

class Enemy extends PositionComponent {
  double hp;
  final double maxHp;
  bool isFlashing = false;

  Enemy({required Vector2 position, required this.maxHp})
      : hp = maxHp,
        super(position: position, size: Vector2(100, 100));

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = isFlashing ? Colors.white : Colors.redAccent;
    canvas.drawRect(size.toRect(), paint);

    final hpPercent = hp / maxHp;
    final hpPaint = Paint()..color = Colors.greenAccent;
    final bgPaint = Paint()..color = Colors.grey.shade700;

    canvas.drawRect(Rect.fromLTWH(0, -15, size.x, 8), bgPaint);
    canvas.drawRect(Rect.fromLTWH(0, -15, size.x * hpPercent, 8), hpPaint);

    final text = TextPaint(style: const TextStyle(fontSize: 14, color: Colors.white));
    text.render(canvas, "ENEMY", Vector2(10, size.y + 5));
  }

  void takeDamage(double dmg) {
    hp -= dmg;
    isFlashing = true;
    Future.delayed(const Duration(milliseconds: 150), () {
      isFlashing = false;
    });

    if (hp <= 0) {
      removeFromParent();
    }
  }

  bool get isAlive => hp > 0;
}

// ─────────────────────────────────────────────

class Player extends PositionComponent {
  bool isAttacking = false;

  Player({required Vector2 position})
      : super(position: position, size: Vector2(100, 100));

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = isAttacking ? Colors.orangeAccent : Colors.blueAccent;

    canvas.drawRRect(
      RRect.fromRectAndRadius(size.toRect(), Radius.circular(10)),
      paint,
    );

    final tp = TextPaint(style: TextStyle(fontSize: 14, color: Colors.white));
    tp.render(canvas, "YOU", Vector2(25, size.y + 5));
  }

  void attack() {
    isAttacking = true;
    Future.delayed(const Duration(milliseconds: 300), () {
      isAttacking = false;
    });
  }
}
