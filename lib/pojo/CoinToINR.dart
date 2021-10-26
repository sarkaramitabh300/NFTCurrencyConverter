// To parse this JSON data, do
//
//     final coinToInr = coinToInrFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CoinToInr coinToInrFromJson(String str) => CoinToInr.fromJson(json.decode(str));

String coinToInrToJson(CoinToInr data) => json.encode(data.toJson());

class CoinToInr {
  CoinToInr({
    required this.status,
    required this.data,
  });

  Status status;
  Data data;

  factory CoinToInr.fromJson(Map<String, dynamic> json) => CoinToInr(
        status: Status.fromJson(json["status"]),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status.toJson(),
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.id,
    required this.symbol,
    required this.name,
    required this.amount,
    required this.lastUpdated,
    required this.quote,
  });

  int id;
  String symbol;
  String name;
  num amount;
  DateTime lastUpdated;
  Quote quote;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        symbol: json["symbol"],
        name: json["name"],
        amount: json["amount"],
        lastUpdated: DateTime.parse(json["last_updated"]),
        quote: Quote.fromJson(json["quote"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "symbol": symbol,
        "name": name,
        "amount": amount,
        "last_updated": lastUpdated.toIso8601String(),
        "quote": quote.toJson(),
      };
}

class Quote {
  Quote({
    required this.inr,
  });

  Inr inr;

  factory Quote.fromJson(Map<String, dynamic> json) => Quote(
        inr: Inr.fromJson(json["INR"]),
      );

  Map<String, dynamic> toJson() => {
        "INR": inr.toJson(),
      };
}

class Inr {
  Inr({
    required this.price,
    required this.lastUpdated,
  });

  double price;
  DateTime lastUpdated;

  factory Inr.fromJson(Map<String, dynamic> json) => Inr(
        price: json["price"].toDouble(),
        lastUpdated: DateTime.parse(json["last_updated"]),
      );

  Map<String, dynamic> toJson() => {
        "price": price,
        "last_updated": lastUpdated.toIso8601String(),
      };
}

class Status {
  Status({
    required this.timestamp,
    required this.errorCode,
    required this.errorMessage,
    required this.elapsed,
    required this.creditCount,
    required this.notice,
  });

  DateTime timestamp;
  int errorCode;
  dynamic errorMessage;
  int elapsed;
  int creditCount;
  dynamic notice;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        timestamp: DateTime.parse(json["timestamp"]),
        errorCode: json["error_code"],
        errorMessage: json["error_message"],
        elapsed: json["elapsed"],
        creditCount: json["credit_count"],
        notice: json["notice"],
      );

  Map<String, dynamic> toJson() => {
        "timestamp": timestamp.toIso8601String(),
        "error_code": errorCode,
        "error_message": errorMessage,
        "elapsed": elapsed,
        "credit_count": creditCount,
        "notice": notice,
      };
}
