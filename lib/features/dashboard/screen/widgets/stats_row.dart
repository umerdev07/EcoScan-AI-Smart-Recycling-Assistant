import 'package:eco_scan/features/dashboard/screen/widgets/stat_card_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/dashboard_controler.dart';

class StatsRow extends GetView<DashboardController> {
  const StatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Obx(() {
        final d = controller.dashboard.value;

        return Row(
          children: [
            StatBox(
              label: 'Total Scans',
              value: '${d.totalScans}',
              icon: Icons.document_scanner_outlined,
              color: const Color(0xFF4ECDC4),
            ),
            const SizedBox(width: 10),
            StatBox(
              label: 'DIY Done',
              value: '${d.diyDone}',
              icon: Icons.lightbulb_outline,
              color: const Color(0xFFFFD166),
            ),
            const SizedBox(width: 10),
            StatBox(
              label: 'Eco Points',
              value: '${d.points}',
              icon: Icons.eco,
              color: const Color(0xFF00C896),
            ),
          ],
        );
      }),
    );
  }
}