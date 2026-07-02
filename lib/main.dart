// In your main.dart or app.dart, apply the binding at the ROOT level like this:
//
// GetMaterialApp(
//   initialBinding: AppBinding(),   // ← registers ALL controllers at startup
//   initialRoute: '/',
//   ...
// )
//
// DO NOT pass a binding inside Get.to() calls — that creates a second,
// separate instance of the controller which is why ScanController was not found.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'binding/dashboard_binding/dashboard_binding.dart';
import 'features/dashboard/screen/dashboard_screen.dart';

void main() {
  runApp(const EcoScanApp());
}

class EcoScanApp extends StatelessWidget {
  const EcoScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'EcoScan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialBinding: AppBinding(), // ← THIS is where binding goes
      home: const DashboardPage(),
    );
  }
}