import 'package:eco_scan/features/dashboard/screen/widgets/header_widget.dart';
import 'package:eco_scan/features/dashboard/screen/widgets/recent_scan.dart';
import 'package:eco_scan/features/dashboard/screen/widgets/scan_card_widget.dart';
import 'package:eco_scan/features/dashboard/screen/widgets/stats_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/dashboard_controler.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1F1A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              DashboardHeader(),
              SizedBox(height: 20),
              ScanCard(),
              SizedBox(height: 16),
              StatsRow(),
              SizedBox(height: 24),
              HistorySection(),
            ],
          ),
        ),
      ),
    );
  }
}