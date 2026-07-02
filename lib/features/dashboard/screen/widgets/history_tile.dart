import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/save_scan_model.dart';

class HistoryTile extends StatelessWidget {
  final SavedScan scan;
  final VoidCallback onDelete;

  const HistoryTile({required this.scan, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(scan.objectName + scan.savedAt.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFFF6B6B).withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_outline_rounded,
            color: Color(0xFFFF6B6B), size: 22),
      ),
      onDismissed: (_) => onDelete(),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF152B23),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF1E3D30)),
        ),
        child: Row(
          children: [
            /// Recyclable indicator dot
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: scan.isRecyclable
                    ? const Color(0xFF00C896).withOpacity(0.12)
                    : const Color(0xFFFF6B6B).withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                scan.isRecyclable
                    ? Icons.recycling_rounded
                    : Icons.delete_outline_rounded,
                color: scan.isRecyclable
                    ? const Color(0xFF00C896)
                    : const Color(0xFFFF6B6B),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),

            /// Name + description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    scan.objectName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    scan.shortDescription,
                    style: const TextStyle(
                      color: Color(0xFF4A7A65),
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${scan.reuseIdeas.length} DIY ideas  •  ${scan.timeAgo}',
                    style: const TextStyle(
                      color: Color(0xFF4A7A65),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            /// Eco points badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: const Color(0xFF4CAF50).withOpacity(0.3)),
              ),
              child: Text(
                '+${scan.ecoPoints}',
                style: const TextStyle(
                  color: Color(0xFF9CCC65),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}