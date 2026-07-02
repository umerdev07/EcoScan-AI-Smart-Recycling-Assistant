import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/dashboard_controler.dart';

class DashboardHeader extends GetView<DashboardController> {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'EcoScan',
                  style: TextStyle(
                    color: Color(0xFF00C896),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Good work, keep\nscanning! 🌱',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Obx(() {
            final pts = controller.dashboard.value.points;

            return Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF1A3328),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  const Text('🌿'),
                  Text(
                    '$pts',
                    style: const TextStyle(
                      color: Color(0xFF00C896),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'pts',
                    style: TextStyle(
                      color: Color(0xFF4A7A65),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}