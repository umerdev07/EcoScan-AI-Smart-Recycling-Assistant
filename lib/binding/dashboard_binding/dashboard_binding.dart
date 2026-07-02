import 'package:get/get.dart';

import '../../features/dashboard/controller/dashboard_controler.dart';
import '../../features/scan/controller/scan_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Use Get.put so controllers are available immediately, not lazily
    Get.put<DashboardController>(DashboardController(), permanent: true);
    Get.put<ScanController>(ScanController(), permanent: true);
  }
}