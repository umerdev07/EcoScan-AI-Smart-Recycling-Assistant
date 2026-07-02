import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../controller/find_center_controller.dart';
import '../model/recyclar_center_model.dart';

class FindCenterPage extends StatelessWidget {
  const FindCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FindCenterController());

    return Scaffold(
      backgroundColor: const Color(0xFF0D1F1A),
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) return _LoadingView();
                if (controller.errorMessage.isNotEmpty) {
                  return _ErrorView(
                    message: controller.errorMessage.value,
                    onRetry: controller.retry,
                  );
                }
                return _MapAndList(controller: controller);
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// TOP BAR
// ─────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF1A3328),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_back_ios_new,
                  color: Colors.white70, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find Recycling Center',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  'Lahore recycling & scrap locations',
                  style: TextStyle(color: Color(0xFF4A7A65), fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// LOADING
// ─────────────────────────────────────────────
class _LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: Color(0xFF00C896)),
          SizedBox(height: 16),
          Text(
            'Finding recycling centers\nnear you...',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF4A7A65), fontSize: 14),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ERROR
// ─────────────────────────────────────────────
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_off_outlined,
                color: Color(0xFFFF6B6B), size: 48),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white70, fontSize: 14, height: 1.6),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C896),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// MAP + LIST
// ─────────────────────────────────────────────
class _MapAndList extends StatelessWidget {
  final FindCenterController controller;
  const _MapAndList({required this.controller});

  Color _pinColor(String type) {
    if (type.contains('Scrap')) return const Color(0xFFFFD166);
    if (type.contains('Composting')) return const Color(0xFF00C896);
    if (type.contains('Transfer') || type.contains('Waste Management')) {
      return const Color(0xFFFF6B6B);
    }
    if (type.contains('NGO')) return const Color(0xFFFF9F43);
    return const Color(0xFF4ECDC4);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// ── MAP top 55% ──────────────────────
        Expanded(
          flex: 55,
          child: Stack(
            children: [
              Obx(() => FlutterMap(
                mapController: controller.mapController,
                options: MapOptions(
                  initialCenter: LatLng(
                    controller.userLat.value,
                    controller.userLng.value,
                  ),
                  initialZoom: 13,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.eco_scan',
                  ),
                  MarkerLayer(
                    markers: [
                      // User marker
                      Marker(
                        point: LatLng(
                          controller.userLat.value,
                          controller.userLng.value,
                        ),
                        width: 44,
                        height: 44,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF00C896),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.white, width: 2.5),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00C896)
                                    .withOpacity(0.5),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.person,
                              color: Colors.white, size: 22),
                        ),
                      ),

                      // Center markers
                      ...controller.centers.map(
                            (c) => Marker(
                          point: LatLng(c.lat, c.lng),
                          width: 38,
                          height: 38,
                          child: GestureDetector(
                            onTap: () => controller.focusCenter(c),
                            child: Container(
                              decoration: BoxDecoration(
                                color: _pinColor(c.type),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                    Colors.black.withOpacity(0.25),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                  Icons.recycling_rounded,
                                  color: Colors.white,
                                  size: 18),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),

              // My location button
              Positioned(
                bottom: 12,
                right: 12,
                child: GestureDetector(
                  onTap: controller.focusUser,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFF152B23),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF1E3D30)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 6),
                      ],
                    ),
                    child: const Icon(Icons.my_location_rounded,
                        color: Color(0xFF00C896), size: 20),
                  ),
                ),
              ),

              // Legend
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF152B23).withOpacity(0.92),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF1E3D30)),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LegendDot(
                          color: Color(0xFF00C896), label: 'You / Composting'),
                      SizedBox(height: 4),
                      _LegendDot(
                          color: Color(0xFFFFD166), label: 'Scrap Market'),
                      SizedBox(height: 4),
                      _LegendDot(
                          color: Color(0xFFFF9F43), label: 'Recycling NGO'),
                      SizedBox(height: 4),
                      _LegendDot(
                          color: Color(0xFF4ECDC4), label: 'Recycling Point'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        /// ── BOTTOM LIST 45% ──────────────────
        Expanded(
          flex: 45,
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF0D1F1A),
              borderRadius:
              BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
                  child: Row(
                    children: [
                      const Icon(Icons.recycling_rounded,
                          color: Color(0xFF00C896), size: 18),
                      const SizedBox(width: 8),
                      Obx(() => Text(
                        '${controller.centers.length} Centers Found',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                      const Spacer(),
                      const Text(
                        'Tap pin to focus',
                        style: TextStyle(
                            color: Color(0xFF4A7A65), fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Color(0xFF1E3D30), height: 1),
                Expanded(
                  child: Obx(() {
                    if (controller.centers.isEmpty) {
                      return const Center(
                        child: Text(
                          'No centers found.',
                          style: TextStyle(
                              color: Color(0xFF4A7A65), fontSize: 13),
                        ),
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      itemCount: controller.centers.length,
                      separatorBuilder: (_, __) =>
                      const SizedBox(height: 8),
                      itemBuilder: (_, i) => _CenterTile(
                        center: controller.centers[i],
                        onTap: () =>
                            controller.focusCenter(controller.centers[i]),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// LEGEND DOT
// ─────────────────────────────────────────────
class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label,
            style: const TextStyle(
                color: Colors.white70, fontSize: 10)),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// CENTER TILE
// ─────────────────────────────────────────────
class _CenterTile extends StatelessWidget {
  final RecyclingCenter center;
  final VoidCallback onTap;
  const _CenterTile({required this.center, required this.onTap});

  Color _typeColor(String type) {
    if (type.contains('Scrap')) return const Color(0xFFFFD166);
    if (type.contains('Composting')) return const Color(0xFF00C896);
    if (type.contains('NGO')) return const Color(0xFFFF9F43);
    if (type.contains('Transfer') || type.contains('Waste Management')) {
      return const Color(0xFFFF6B6B);
    }
    return const Color(0xFF4ECDC4);
  }

  @override
  Widget build(BuildContext context) {
    final color = _typeColor(center.type);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF152B23),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF1E3D30)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.recycling_rounded, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    center.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    center.type,
                    style: TextStyle(color: color, fontSize: 11),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    center.address,
                    style: const TextStyle(
                        color: Color(0xFF4A7A65), fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Text(
                '${center.distanceKm} km',
                style: TextStyle(
                  color: color,
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