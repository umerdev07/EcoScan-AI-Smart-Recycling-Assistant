import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfidenceCard extends StatelessWidget {
  final double confidence;
  const ConfidenceCard({required this.confidence});

  Color get _barColor {
    if (confidence >= 0.75) return const Color(0xFF00C896);
    if (confidence >= 0.5) return const Color(0xFFFFD166);
    return const Color(0xFFFF6B6B);
  }

  String get _label {
    if (confidence >= 0.75) return 'High';
    if (confidence >= 0.5) return 'Medium';
    return 'Low';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF152B23),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1E3D30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics_outlined, color: _barColor, size: 18),
              const SizedBox(width: 8),
              const Text(
                'AI Confidence',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '$_label  ${(confidence * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  color: _barColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: confidence,
              minHeight: 8,
              backgroundColor: const Color(0xFF1E3D30),
              valueColor: AlwaysStoppedAnimation<Color>(_barColor),
            ),
          ),
        ],
      ),
    );
  }
}
