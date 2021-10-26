// To parse this JSON data, do
//
//     final apiResponse = apiResponseFromJson(jsonString);

import 'dart:convert';

ApiResponse apiResponseFromJson(String str) => ApiResponse.fromJson(json.decode(str));

String apiResponseToJson(ApiResponse data) => json.encode(data.toJson());

class ApiResponse {
  List<Rows> rows;
  bool more;
  String nextKey;

  ApiResponse({
    required this.rows,
    required this.more,
    required this.nextKey,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
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

  String account;
  int energy;
  int maxEnergy;
  String lastMineTx;
  List<String> balances;

  Rows({
    required this.account,
    required this.energy,
    required this.maxEnergy,
    required this.lastMineTx,
    required this.balances,
  });

  factory Rows.fromJson(Map<String, dynamic> json) => Rows(
    account: json["account"],
    energy: json["energy"],
    maxEnergy: json["max_energy"],
    lastMineTx: json["last_mine_tx"],
    balances: List<String>.from(json["balances"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "account": account,
    "energy": energy,
    "max_energy": maxEnergy,
    "last_mine_tx": lastMineTx,
    "balances": List<dynamic>.from(balances.map((x) => x)),
  };
}
