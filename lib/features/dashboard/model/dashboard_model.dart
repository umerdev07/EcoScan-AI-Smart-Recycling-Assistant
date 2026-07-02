class DashboardModel {
  final int totalScans;
  final int diyDone;
  final int points;

  DashboardModel({
    required this.totalScans,
    required this.diyDone,
    required this.points,
  });

  DashboardModel copyWith({int? totalScans, int? diyDone, int? points}) {
    return DashboardModel(
      totalScans: totalScans ?? this.totalScans,
      diyDone: diyDone ?? this.diyDone,
      points: points ?? this.points,
    );
  }
}