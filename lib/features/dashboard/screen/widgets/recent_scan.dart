import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/dashboard_controler.dart';
import 'empty_widget.dart';
import 'history_tile.dart';

class HistorySection extends GetView<DashboardController> {
  const HistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Scan History',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Obx(() {
          if (controller.savedScans.isEmpty) {
            return const EmptyHistory();
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: controller.savedScans.length,
            separatorBuilder: (_, __) =>
            const SizedBox(height: 10),
            itemBuilder: (context, index) {
              return HistoryTile(
                scan: controller.savedScans[index],
                onDelete: () =>
                    controller.deleteScan(index),
              );
            },
          );
        }),
      ],
    );
  }
}