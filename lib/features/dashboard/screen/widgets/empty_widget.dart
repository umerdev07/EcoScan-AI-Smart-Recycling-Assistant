import 'package:flutter/material.dart';

class EmptyHistory extends StatelessWidget {
  const EmptyHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFF152B23),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Column(
        children: [
          Text(
            '🌿',
            style: TextStyle(fontSize: 36),
          ),
          SizedBox(height: 10),
          Text(
            'No saved scans yet',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}