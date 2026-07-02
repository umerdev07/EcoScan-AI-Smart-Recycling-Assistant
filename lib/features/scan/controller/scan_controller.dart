import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/scan_result_model.dart';
import '../screen/scan_result/scan_result.dart';
import '../service/gemini_service.dart';
import '../service/gemini_vision_image.dart';

class ScanController extends GetxController {
  late CameraController cameraController;

  final isCameraInitialized = false.obs;
  final detectedObject = "Waiting...".obs;
  final isLoading = false.obs;

  final GeminiVisionService visionService = GeminiVisionService();
  final GeminiDiyTextService textService = GeminiDiyTextService();

  @override
  void onInit() {
    super.onInit();
    initCamera();
  }

  Future<void> initCamera() async {
    try {
      final cameras = await availableCameras();
      final camera = cameras.first;

      cameraController = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await cameraController.initialize();
      isCameraInitialized.value = true;
    } catch (e) {
      Get.snackbar(
        'Camera Error',
        'Could not initialize camera: $e',
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> scanObject() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      detectedObject.value = "Scanning...";

      // 1. Capture photo
      final XFile file = await cameraController.takePicture();
      final bytes = await File(file.path).readAsBytes();

      // 2. Detect object via Vision API
      final object = await visionService.detectObjectBytes(bytes);
      detectedObject.value = object;

      // 3. Get full eco insight — returns a ScanResult
      final ScanResult result = await textService.getEcoInsight(object);

      // 4. Auto-navigate to DIY result page
      Get.to(
            () => const DiyResultPage(),
        arguments: result,
        transition: Transition.rightToLeft,
        duration: const Duration(milliseconds: 300),
      );

      // Reset label for next scan
      detectedObject.value = "Waiting...";
    } catch (e) {
      detectedObject.value = "Scan failed";
      Get.snackbar(
        'Scan Failed',
        e.toString(),
        backgroundColor: const Color(0xFFFF6B6B).withOpacity(0.9),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }
}