import 'package:eco_scan/features/findCenter/screen/find_center_page.dart';
import 'package:eco_scan/features/scan/screen/scan_result/widget/bottom_action.dart';
import 'package:eco_scan/features/scan/screen/scan_result/widget/confidence_card.dart';
import 'package:eco_scan/features/scan/screen/scan_result/widget/eco_point_banner.dart';
import 'package:eco_scan/features/scan/screen/scan_result/widget/idea_row.dart';
import 'package:eco_scan/features/scan/screen/scan_result/widget/object_name_card.dart';
import 'package:eco_scan/features/scan/screen/scan_result/widget/section_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../dashboard/controller/dashboard_controler.dart';
import '../../models/scan_result_model.dart';

class DiyResultPage extends StatelessWidget {
  const DiyResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ScanResult result = Get.arguments as ScanResult;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1F1A),
      body: SafeArea(
        child: Column(
          children: [
            /// ── TOP BAR ──────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A3328),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white70,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Scan Result',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),

            /// ── SCROLLABLE CONTENT ───────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ObjectNameCard(result: result),
                    const SizedBox(height: 12),
                    EcoPointsBanner(points: result.ecoPoints),
                    const SizedBox(height: 12),
                    ConfidenceCard(confidence: result.confidence),
                    const SizedBox(height: 12),
                    SectionCard(
                      icon: Icons.recycling_rounded,
                      iconColor: const Color(0xFF4ECDC4),
                      title: 'Recycling Info',
                      child: Text(
                        result.recyclingInfo,
                        style: const TextStyle(
                          color: Color(0xFFB0C4BB),
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SectionCard(
                      icon: Icons.lightbulb_outline_rounded,
                      iconColor: const Color(0xFFFFD166),
                      title: 'DIY Reuse Ideas',
                      child: Column(
                        children: result.reuseIdeas
                            .asMap()
                            .entries
                            .map(
                              (e) => IdeaRow(index: e.key + 1, idea: e.value),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SectionCard(
                      icon: Icons.delete_outline_rounded,
                      iconColor: const Color(0xFFFF6B6B),
                      title: 'Disposal Advice',
                      child: Text(
                        result.disposalAdvice,
                        style: const TextStyle(
                          color: Color(0xFFB0C4BB),
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            /// ── BOTTOM BUTTONS ───────────────────────
            BottomActions(result: result),
          ],
        ),
      ),
    );
  }
}