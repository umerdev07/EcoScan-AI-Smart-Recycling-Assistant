import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/scan_result_model.dart';

class ObjectNameCard extends StatelessWidget {
  final ScanResult result;
  const ObjectNameCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A4A38), Color(0xFF0F2D22)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2D6B50), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF00C896).withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFF00C896).withOpacity(0.4),
              ),
            ),
            child: const Icon(
              Icons.search_rounded,
              color: Color(0xFF00C896),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'DETECTED OBJECT',
                  style: TextStyle(
                    color: Color(0xFF00C896),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  result.objectName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  result.shortDescription,
                  style: const TextStyle(
                    color: Color(0xFF8AADA0),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: result.isRecyclable
                  ? const Color(0xFF00C896).withOpacity(0.15)
                  : const Color(0xFFFF6B6B).withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: result.isRecyclable
                    ? const Color(0xFF00C896).withOpacity(0.5)
                    : const Color(0xFFFF6B6B).withOpacity(0.5),
              ),
            ),
            child: Text(
              result.isRecyclable ? '♻ Yes' : '✕ No',
              style: TextStyle(
                color: result.isRecyclable
                    ? const Color(0xFF00C896)
                    : const Color(0xFFFF6B6B),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
