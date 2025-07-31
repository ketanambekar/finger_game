import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  final List<String> games = [
    'Shadow Touch',
    'Splat Escape',
    'Lava Hold',
    'Nerve Line',
    'Spider Flick',
    'Combat'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Text('🕹️ TAP SURVIVAL', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: games.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                      child: ElevatedButton(
                        onPressed: () {
                            final game = games[index];
                            switch (game) {
                              case 'Shadow Touch':
                                Get.toNamed('/shadow-touch');
                                break;
                              case 'Lava Hold':
                                Get.toNamed('/lava-hold');
                                break;
                              case 'Splat Escape':
                                Get.toNamed('/splat-escape');
                                break;
                              case 'Nerve Line':
                                Get.toNamed('/nerve-line');
                                break;
                              case 'Spider Flick':
                              Get.toNamed('/spider-flick');
                              break;
                              case 'Combat':
                                Get.toNamed('/combat');
                                break;
                              default:
                                Get.snackbar("Coming Soon", "$game is under development");
                            }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          games[index].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 18,
                            letterSpacing: 2,
                            color: Colors.white
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
