class RecentlyVisited {
  final int appId;
  final String typeId;
  final String title;
  final String appType;
  final String appRoute;
  final double? coachPercent;
  final String? completedPercent;
  final String? totalPercent;


  RecentlyVisited({
    required this.appId,
    required this.typeId,
    required this.title,
    required this.appType,
    required this.appRoute,
    this.coachPercent,
    this.totalPercent,
    this.completedPercent

  });
}
