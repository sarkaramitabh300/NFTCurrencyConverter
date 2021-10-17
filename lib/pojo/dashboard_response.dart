// To parse this JSON data, do
//
//     final dashboardResponse = dashboardResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

DashboardResponse dashboardResponseFromJson(String str) =>
    DashboardResponse.fromJson(json.decode(str));

String dashboardResponseToJson(DashboardResponse data) =>
    json.encode(data.toJson());

class DashboardResponse {
  DashboardResponse({
    required this.status,
    required this.data,
  });

  String status;
  Data data;

  factory DashboardResponse.fromJson(Map<String, dynamic> json) =>
      DashboardResponse(
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.statistics,
    required this.workers,
    required this.currentStatistics,
    required this.settings,
  });

  List<CurrentStatistics> statistics;
  List<CurrentStatistics> workers;
  CurrentStatistics currentStatistics;
  Settings settings;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        statistics: List<CurrentStatistics>.from(
            json["statistics"].map((x) => CurrentStatistics.fromJson(x))),
        workers: List<CurrentStatistics>.from(
            json["workers"].map((x) => CurrentStatistics.fromJson(x))),
        currentStatistics:
            CurrentStatistics.fromJson(json["currentStatistics"]),
        settings: Settings.fromJson(json["settings"]),
      );

  Map<String, dynamic> toJson() => {
        "statistics": List<dynamic>.from(statistics.map((x) => x.toJson())),
        "workers": List<dynamic>.from(workers.map((x) => x.toJson())),
        "currentStatistics": currentStatistics.toJson(),
        "settings": settings.toJson(),
      };
}

class CurrentStatistics {
  CurrentStatistics({
    required this.time,
    required this.lastSeen,
    required this.reportedHashrate,
    required this.currentHashrate,
    required this.validShares,
    required this.invalidShares,
    required this.staleShares,
    required this.activeWorkers,
    required this.unpaid,
    required this.worker,
  });

  int time;
  int lastSeen;
  int reportedHashrate;
  double currentHashrate;
  int validShares;
  int invalidShares;
  int staleShares;
  int activeWorkers;
  int unpaid;
  String worker;

  factory CurrentStatistics.fromJson(Map<String, dynamic> json) =>
      CurrentStatistics(
        time: json["time"],
        lastSeen: json["lastSeen"] == null ? 0 : json["lastSeen"],
        reportedHashrate: json["reportedHashrate"],
        currentHashrate: json["currentHashrate"].toDouble(),
        validShares: json["validShares"],
        invalidShares: json["invalidShares"],
        staleShares: json["staleShares"],
        activeWorkers:
            json["activeWorkers"] == null ? 0 : json["activeWorkers"],
        unpaid: json["unpaid"] == null ? 0 : json["unpaid"],
        worker: json["worker"] == null ? "" : json["worker"],
      );

  Map<String, dynamic> toJson() => {
        "time": time,
        // "lastSeen": lastSeen == null ? null : lastSeen,
        "reportedHashrate": reportedHashrate,
        "currentHashrate": currentHashrate,
        "validShares": validShares,
        "invalidShares": invalidShares,
        "staleShares": staleShares,
        "activeWorkers": activeWorkers == null ? 0 : activeWorkers,
        "unpaid": unpaid == null ? null : unpaid,
        "worker": worker == null ? null : worker,
      };
}

class Settings {
  Settings({
    required this.monitor,
    required this.minPayout,
    required this.email,
  });

  int monitor;
  double minPayout;
  String email;

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
        monitor: json["monitor"],
        minPayout: json["minPayout"].toDouble(),
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "monitor": monitor,
        "minPayout": minPayout,
        "email": email,
      };
}
