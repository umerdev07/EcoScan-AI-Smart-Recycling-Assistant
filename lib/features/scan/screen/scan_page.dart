import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/scan_controller.dart';

class ScanPage extends GetView<ScanController> {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (!controller.isCameraInitialized.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF00C896)),
          );
        }

        return Stack(
          children: [
            /// 📷 CAMERA PREVIEW
            SizedBox.expand(
              child: CameraPreview(controller.cameraController),
            ),

            /// 🟩 SCAN FRAME
            Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF00C896), width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),

            /// 🏷️ STATUS — shows detected object name while scanning
            Positioned(
              bottom: 130,
              left: 20,
              right: 20,
              child: Obx(() => Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.65),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: const Color(0xFF00C896).withOpacity(0.4)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search_rounded,
                        color: Color(0xFF00C896), size: 16),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        controller.detectedObject.value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              )),
            ),

            /// 📸 SCAN BUTTON
            Positioned(
              bottom: 48,
              left: 40,
              right: 40,
              child: Obx(() {
                final loading = controller.isLoading.value;
                return ElevatedButton(
                  onPressed: loading ? null : controller.scanObject,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C896),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: loading
                      ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                      : const Text(
                    'SCAN NOW',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      }),
    );
  }
}