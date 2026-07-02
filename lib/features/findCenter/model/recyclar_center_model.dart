import 'dart:math';

class RecyclingCenter {
  final String name;
  final String address;
  final double lat;
  final double lng;
  final double distanceKm;
  final String type;

  RecyclingCenter({
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    required this.distanceKm,
    required this.type,
  });

  factory RecyclingCenter.fromOverpass(
      Map<String, dynamic> json, double userLat, double userLng) {
    final lat = (json['lat'] as num).toDouble();
    final lng = (json['lon'] as num).toDouble();
    final tags = json['tags'] as Map<String, dynamic>? ?? {};

    final street = tags['addr:street'] ?? '';
    final city = tags['addr:city'] ?? '';
    final address = [street, city].where((s) => s.isNotEmpty).join(', ');

    final name = tags['name'] ??
        tags['operator'] ??
        _typeLabel(tags['amenity'], tags['recycling_type'], tags['shop']);

    final dist = calcDistance(userLat, userLng, lat, lng);

    return RecyclingCenter(
      name: name,
      address: address.isNotEmpty ? address : 'See on map',
      lat: lat,
      lng: lng,
      distanceKm: double.parse(dist.toStringAsFixed(1)),
      type: _typeLabel(tags['amenity'], tags['recycling_type'], tags['shop']),
    );
  }

  static String _typeLabel(
      String? amenity, String? recyclingType, String? shop) {
    if (shop == 'scrap_metal') return 'Scrap Metal Dealer';
    if (shop == 'second_hand') return 'Second Hand / Reuse Shop';
    if (recyclingType == 'container') return 'Recycling Container';
    if (recyclingType == 'centre') return 'Recycling Centre';
    if (amenity == 'waste_disposal') return 'Waste Disposal';
    if (amenity == 'waste_transfer_station') return 'Transfer Station';
    return 'Recycling Point';
  }

  // ── Public so OverpassService can use it for hardcoded entries ──
  static double calcDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const r = 6371.0;
    final dLat = _rad(lat2 - lat1);
    final dLon = _rad(lon2 - lon1);
    final a = pow(sin(dLat / 2), 2) +
        cos(_rad(lat1)) * cos(_rad(lat2)) * pow(sin(dLon / 2), 2);
    return r * 2 * asin(sqrt(a));
  }

  static double _rad(double deg) => deg * pi / 180;
}