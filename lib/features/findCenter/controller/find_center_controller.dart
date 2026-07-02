import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../model/recyclar_center_model.dart';
import '../service/places_service.dart';

class FindCenterController extends GetxController {
  final OverpassService _service = OverpassService();

  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final centers = <RecyclingCenter>[].obs;
  final selectedCenter = Rxn<RecyclingCenter>();

  final userLat = 0.0.obs;
  final userLng = 0.0.obs;

  MapController mapController = MapController();

  @override
  void onInit() {
    super.onInit();
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final position = await _getLocation();
      userLat.value = position.latitude;
      userLng.value = position.longitude;

      await _fetchCenters();
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      isLoading.value = false;
    }
  }

  Future<Position> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled. Please enable GPS.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permanently denied. Enable it in app Settings.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> _fetchCenters() async {
    final list = await _service.getNearbyRecyclingCenters(
      lat: userLat.value,
      lng: userLng.value,
    );
    centers.value = list;
    isLoading.value = false;
  }

  void focusCenter(RecyclingCenter center) {
    selectedCenter.value = center;
    mapController.move(LatLng(center.lat, center.lng), 16);
  }

  void focusUser() {
    mapController.move(LatLng(userLat.value, userLng.value), 14);
  }

  void retry() => _initLocation();

  @override
  void onClose() {
    mapController.dispose();
    super.onClose();
  }
}