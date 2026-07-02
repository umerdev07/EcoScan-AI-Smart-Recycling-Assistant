import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';

import '../../../../dashboard/controller/dashboard_controler.dart';
import '../../../../findCenter/screen/find_center_page.dart';
import 'bottom_action.dart';

class BottomActionsState extends State<BottomActions> {
  bool _saved = false;

  void _onSave() {
    if (_saved) return;

    // Find DashboardController and save
    final dashController = Get.find<DashboardController>();
    dashController.saveResult(
      objectName: widget.result.objectName,
      shortDescription: widget.result.shortDescription,
      isRecyclable: widget.result.isRecyclable,
      ecoPoints: widget.result.ecoPoints,
      reuseIdeas: widget.result.reuseIdeas,
      recyclingInfo: widget.result.recyclingInfo,
      disposalAdvice: widget.result.disposalAdvice,
    );

    setState(() => _saved = true);

    Get.snackbar(
      '✅ Saved',
      '${widget.result.objectName} added to your history.',
      backgroundColor: const Color(0xFF00C896),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: const BoxDecoration(
        color: Color(0xFF0D1F1A),
        border: Border(top: BorderSide(color: Color(0xFF1E3D30))),
      ),
      child: Row(
        children: [
          /// FIND NEARBY CENTER
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                Get.to(
                      () => const FindCenterPage(),
                  transition: Transition.rightToLeft,
                  duration: const Duration(milliseconds: 300),
                );
              },
              icon: const Icon(Icons.location_on_outlined, size: 18),
              label: const Text('Find Center'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF4ECDC4),
                side: const BorderSide(color: Color(0xFF4ECDC4), width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          /// SAVE
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _saved ? null : _onSave,
              icon: Icon(
                _saved ? Icons.bookmark_rounded : Icons.bookmark_add_outlined,
                size: 18,
              ),
              label: Text(_saved ? 'Saved' : 'Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _saved
                    ? const Color(0xFF1A3328)
                    : const Color(0xFF00C896),
                foregroundColor: _saved
                    ? const Color(0xFF4A7A65)
                    : Colors.white,
                disabledBackgroundColor: const Color(0xFF1A3328),
                disabledForegroundColor: const Color(0xFF4A7A65),
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
