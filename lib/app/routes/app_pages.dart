import 'package:get/get.dart';
import 'package:tap_survival/modules/combat/combat_view.dart';
import 'package:tap_survival/modules/games/lava_hold/lava_hold_view.dart';
import 'package:tap_survival/modules/games/nerve_line/nerve_line_view.dart';
import 'package:tap_survival/modules/games/shadow_touch/shadow_touch_view.dart';
import 'package:tap_survival/modules/games/spider_flick/spider_flick_view.dart';
import 'package:tap_survival/modules/games/splat_escape/splat_escape_view.dart';
import 'package:tap_survival/modules/home/home_view.dart';

class AppPages {
  static final routes = [
    GetPage(name: '/', page: () => HomeView()),
    GetPage(name: '/shadow-touch', page: () => ShadowTouchView()),
    GetPage(name: '/lava-hold', page: () => LavaHoldView()),
    GetPage(name: '/splat-escape', page: () => SplatEscapeView()),
    GetPage(name: '/nerve-line', page: () => NerveLineView()),
    GetPage(name: '/spider-flick', page: () => SpiderFlickView()),
    GetPage(name: '/combat', page: () => CombatView()),

    // Add your game pages here
  ];
}
