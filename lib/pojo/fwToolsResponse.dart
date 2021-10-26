// To parse this JSON data, do
//
//     final fwToolsResponse = fwToolsResponseFromJson(jsonString);

import 'dart:convert';

FwToolsResponse fwToolsResponseFromJson(String str) => FwToolsResponse.fromJson(json.decode(str));

String fwToolsResponseToJson(FwToolsResponse data) => json.encode(data.toJson());

class FwToolsResponse {
  FwToolsResponse({
    required this.rows,
    required this.more,
    required this.nextKey,
  });

  List<Rows> rows;
  bool more;
  String nextKey;

  factory FwToolsResponse.fromJson(Map<String, dynamic> json) => FwToolsResponse(
    rows: List<Rows>.from(json["rows"].map((x) => Rows.fromJson(x))),
    more: json["more"],
    nextKey: json["next_key"],
  );

  Map<String, dynamic> toJson() => {
    "rows": List<dynamic>.from(rows.map((x) => x.toJson())),
    "more": more,
    "next_key": nextKey,
  };
}

class Rows {
  Rows({
    required this.assetId,
    required this.owner,
    required this.type,
    required this.templateId,
    required this.durability,
    required this.currentDurability,
    required this.nextAvailability,
  });

  String assetId;
  String owner;
  String type;
  int templateId;
  int durability;
  int currentDurability;
  int nextAvailability;

  factory Rows.fromJson(Map<String, dynamic> json) => Rows(
    assetId: json["asset_id"],
    owner: json["owner"],
    type: json["type"],
    templateId: json["template_id"],
    durability: json["durability"],
    currentDurability: json["current_durability"],
    nextAvailability: json["next_availability"],
  );

  Map<String, dynamic> toJson() => {
    "asset_id": assetId,
    "owner": owner,
    "type": type,
    "template_id": templateId,
    "durability": durability,
    "current_durability": currentDurability,
    "next_availability": nextAvailability,
  };
}
