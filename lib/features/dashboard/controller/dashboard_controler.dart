import 'package:get/get.dart';

import '../model/dashboard_model.dart';
import '../model/save_scan_model.dart';

class DashboardController extends GetxController {
  // ── Stats ──────────────────────────────────────────────
  final dashboard = DashboardModel(
    totalScans: 0,
    diyDone: 0,
    points: 0,
  ).obs;

  // ── Saved scan history ─────────────────────────────────
  final savedScans = <SavedScan>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadSeedData(); // seed with demo data; replace with Hive later
  }

  // ── Called from DiyResultPage when user taps Save ──────
  void saveResult({
    required String objectName,
    required String shortDescription,
    required bool isRecyclable,
    required int ecoPoints,
    required List<String> reuseIdeas,
    required String recyclingInfo,
    required String disposalAdvice,
  }) {
    final scan = SavedScan.fromScanResult(
      objectName: objectName,
      shortDescription: shortDescription,
      isRecyclable: isRecyclable,
      ecoPoints: ecoPoints,
      reuseIdeas: reuseIdeas,
      recyclingInfo: recyclingInfo,
      disposalAdvice: disposalAdvice,
    );

    savedScans.insert(0, scan); // newest first

    // Update stats
    dashboard.value = dashboard.value.copyWith(
      totalScans: dashboard.value.totalScans + 1,
      diyDone: dashboard.value.diyDone + reuseIdeas.length,
      points: dashboard.value.points + ecoPoints,
    );
  }

  void deleteScan(int index) {
    if (index < 0 || index >= savedScans.length) return;
    final scan = savedScans[index];
    dashboard.value = dashboard.value.copyWith(
      totalScans: (dashboard.value.totalScans - 1).clamp(0, 9999),
      diyDone: (dashboard.value.diyDone - scan.reuseIdeas.length).clamp(0, 9999),
      points: (dashboard.value.points - scan.ecoPoints).clamp(0, 9999),
    );
    savedScans.removeAt(index);
  }

  // ── Seed demo data ─────────────────────────────────────
  void _loadSeedData() {
    /*final demo = [
      SavedScan(
        objectName: 'Plastic Bottle',
        shortDescription: 'A single-use PET plastic water bottle.',
        isRecyclable: true,
        ecoPoints: 15,
        reuseIdeas: ['Watering can', 'Pen holder', 'Bird feeder'],
        recyclingInfo: 'Drop in blue recycling bin. Remove cap first.',
        disposalAdvice: 'Rinse before recycling.',
        savedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      SavedScan(
        objectName: 'Cardboard Box',
        shortDescription: 'Corrugated cardboard shipping box.',
        isRecyclable: true,
        ecoPoints: 20,
        reuseIdeas: ['Storage box', 'Kids fort', 'Moving box'],
        recyclingInfo: 'Flatten and place in paper recycling.',
        disposalAdvice: 'Remove tape and staples before recycling.',
        savedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
*/
    // savedScans.addAll(demo);
   /* dashboard.value = DashboardModel(
      totalScans: 2,
      diyDone: 6,
      points: 35,
    );*/
  }
}