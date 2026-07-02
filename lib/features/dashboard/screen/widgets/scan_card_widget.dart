import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../scan/screen/scan_page.dart';

class ScanCard extends StatelessWidget {
  const ScanCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => Get.to(
              () => const ScanPage(),
          transition: Transition.downToUp,
          duration: const Duration(milliseconds: 300),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF00C896),
                Color(0xFF00876A),
              ],
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SCAN AN OBJECT',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Discover how to\nreuse & recycle',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Tap to scan →',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                '♻️',
                style: TextStyle(fontSize: 60),
              ),
            ],
          ),
        ),
      ),
    );
  }
}