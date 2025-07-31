import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SpiderFlickGame extends FlameGame with PanDetector, HasCollisionDetection {
  final box = GetStorage();

  final survivalTime = 0.0.obs;
  final flickedCount = 0.obs;

  late TimerComponent scoreTimer;
  final List<Spider> spiders = [];
  final Random random = Random();

  late Vector2 center;
  late CircleComponent playerBase;

  @override
  Color backgroundColor() => const Color(0xFF1B1B1B);

  @override
  Future<void> onLoad() async {
    center = size / 2;

    playerBase = CircleComponent(
      radius: 30,
      paint: Paint()..color = Colors.greenAccent,
      position: center - Vector2.all(30),
    );
    add(playerBase);

    scoreTimer = TimerComponent(
      period: 0.1,
      repeat: true,
      onTick: () {
        survivalTime.value += 0.1;
        if (random.nextDouble() < 0.05) {
          _spawnSpider();
        }
      },
    );

    add(scoreTimer);
  }

  void _spawnSpider() {
    final radius = max(size.x, size.y) / 2 + 50;
    final angle = random.nextDouble() * 2 * pi;
    final pos = center + Vector2(cos(angle), sin(angle)) * radius;
    final spider = Spider(start: pos, target: center.clone());
    spiders.add(spider);
    add(spider);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    final swipeStart = info.eventPosition.global - info.delta.global;
    final swipeEnd = info.eventPosition.global;

    final line = LineSegment(swipeStart, swipeEnd);

    for (final spider in List<Spider>.from(spiders)) {
      if (line.intersectsCircle(spider.position, spider.size.x / 2)) {
        spider.removeFromParent();
        spiders.remove(spider);
        flickedCount.value++;
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    for (final spider in spiders) {
      if (spider.position.distanceTo(center) < 30) {
        _endGame();
        break;
      }
    }
  }

  void _endGame() {
    pauseEngine();

    final oldHigh = box.read('spider_highscore') ?? 0.0;
    if (survivalTime.value > oldHigh) {
      box.write('spider_highscore', survivalTime.value);
    }

    overlays.add('GameOver');
  }
}

class Spider extends CircleComponent with HasGameRef<SpiderFlickGame> {
  final Vector2 target;
  final double speed = 30;

  Spider({required Vector2 start, required this.target})
      : super(radius: 20, position: start, paint: Paint()..color = Colors.redAccent);

  @override
  void update(double dt) {
    super.update(dt);
    final dir = (target - position).normalized();
    position += dir * speed * dt;
  }
}

class LineSegment {
  final Vector2 a;
  final Vector2 b;

  LineSegment(this.a, this.b);

  bool intersectsCircle(Vector2 center, double radius) {
    final ab = b - a;
    final ac = center - a;
    final t = (ac.dot(ab)) / (ab.length2);
    final closest = a + ab * t.clamp(0, 1);
    return closest.distanceTo(center) <= radius;
  }
}
