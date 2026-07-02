import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/recyclar_center_model.dart';

class OverpassService {
  static const String _baseUrl = 'https://overpass-api.de/api/interpreter';

  // ── Hardcoded real Lahore recycling/waste locations ──────────────────
  static const List<Map<String, dynamic>> _lahoreFallback = [
    {
      'name': 'Mehmood Booti Composting Facility',
      'address': 'Mehmood Booti, Lahore',
      'lat': 31.6025,
      'lng': 74.4278,
      'type': 'Composting Plant',
    },
    {
      'name': 'LWMC Head Office',
      'address': 'Queens Road, Lahore',
      'lat': 31.5607,
      'lng': 74.3293,
      'type': 'Waste Management Office',
    },
    {
      'name': 'Waste Busters Lahore',
      'address': 'DHA, Lahore',
      'lat': 31.4816,
      'lng': 74.3991,
      'type': 'Recycling NGO',
    },
    {
      'name': 'Brandreth Road Scrap Market',
      'address': 'Brandreth Road, Lahore',
      'lat': 31.5728,
      'lng': 74.3209,
      'type': 'Scrap & Recycling Market',
    },
    {
      'name': 'Ravi Road Scrap Dealers',
      'address': 'Ravi Road, Lahore',
      'lat': 31.5889,
      'lng': 74.3054,
      'type': 'Scrap & Recycling Market',
    },
    {
      'name': 'Shah Alam Market Scrap',
      'address': 'Shah Alam Market, Lahore',
      'lat': 31.5762,
      'lng': 74.3105,
      'type': 'Scrap & Recycling Market',
    },
    {
      'name': 'Badami Bagh Scrap Market',
      'address': 'Badami Bagh, Lahore',
      'lat': 31.5831,
      'lng': 74.3178,
      'type': 'Scrap & Recycling Market',
    },
    {
      'name': 'LWMC Transfer Station Gulberg',
      'address': 'Gulberg, Lahore',
      'lat': 31.5176,
      'lng': 74.3407,
      'type': 'Waste Transfer Station',
    },
  ];

  Future<List<RecyclingCenter>> getNearbyRecyclingCenters({
    required double lat,
    required double lng,
    int radiusMeters = 5000,
  }) async {
    // 1. Try OSM Overpass first
    final osmResults = await _fetchFromOverpass(lat, lng, radiusMeters);

    // 2. Always add hardcoded Lahore centers with distance calculated
    final hardcoded = _lahoreFallback.map((item) {
      final dist = RecyclingCenter.calcDistance(
        lat, lng,
        item['lat'] as double,
        item['lng'] as double,
      );
      return RecyclingCenter(
        name: item['name'] as String,
        address: item['address'] as String,
        lat: item['lat'] as double,
        lng: item['lng'] as double,
        distanceKm: double.parse(dist.toStringAsFixed(1)),
        type: item['type'] as String,
      );
    }).toList();

    // 3. Merge — OSM first, then hardcoded (deduplicated by name)
    final osmNames = osmResults.map((c) => c.name).toSet();
    final uniqueHardcoded =
    hardcoded.where((c) => !osmNames.contains(c.name)).toList();

    final merged = [...osmResults, ...uniqueHardcoded];
    merged.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));

    return merged.take(20).toList();
  }

  Future<List<RecyclingCenter>> _fetchFromOverpass(
      double lat, double lng, int radiusMeters) async {
    try {
      // Search for recycling + scrap shops on OSM
      final query = '''
[out:json][timeout:25];
(
  node["amenity"="recycling"](around:$radiusMeters,$lat,$lng);
  node["amenity"="waste_disposal"](around:$radiusMeters,$lat,$lng);
  node["amenity"="waste_transfer_station"](around:$radiusMeters,$lat,$lng);
  node["shop"="scrap_metal"](around:$radiusMeters,$lat,$lng);
  node["shop"="second_hand"](around:$radiusMeters,$lat,$lng);
  node["recycling_type"="centre"](around:$radiusMeters,$lat,$lng);
);
out body;
''';

      final uri = Uri.parse(_baseUrl).replace(
        queryParameters: {'data': query},
      );

      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'EcoScanApp/1.0',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) return [];

      final data = jsonDecode(response.body);
      final elements = data['elements'] as List<dynamic>? ?? [];

      return elements
          .map((e) => RecyclingCenter.fromOverpass(
        e as Map<String, dynamic>,
        lat,
        lng,
      ))
          .toList();
    } catch (_) {
      // If Overpass fails for any reason, return empty — fallback handles it
      return [];
    }
  }
}