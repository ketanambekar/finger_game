import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tap_survival/app/routes/app_pages.dart';
import 'package:tap_survival/app/themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); // Initialize local storage
  runApp(TapSurvivalApp());
}

class TapSurvivalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Tap Survival',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.mainTheme,
      getPages: AppPages.routes,
      initialRoute: '/',
    );
  }
}
