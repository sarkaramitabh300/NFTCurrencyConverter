// To parse this JSON data, do
//
//     final alcorMarketResponse = alcorMarketResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

AlcorMarketResponse alcorMarketResponseFromJson(String str) => AlcorMarketResponse.fromJson(json.decode(str));

String alcorMarketResponseToJson(AlcorMarketResponse data) => json.encode(data.toJson());

class AlcorMarketResponse {
  AlcorMarketResponse({
    required this.id,
    required this.baseToken,
    required this.quoteToken,
    required this.minBuy,
    required this.minSell,
    required this.fee,
    required this.lastPrice,
    required this.volume24,
    required this.volumeWeek,
    required this.volumeMonth,
    required this.change24,
    required this.changeWeek,
  });

  int id;
  EToken baseToken;
  EToken quoteToken;
  String minBuy;
  String minSell;
  int fee;
  double lastPrice;
  double volume24;
  double volumeWeek;
  double volumeMonth;
  double change24;
  double changeWeek;

  factory AlcorMarketResponse.fromJson(Map<String, dynamic> json) => AlcorMarketResponse(
    id: json["id"],
    baseToken: EToken.fromJson(json["base_token"]),
    quoteToken: EToken.fromJson(json["quote_token"]),
    minBuy: json["min_buy"],
    minSell: json["min_sell"],
    fee: json["fee"],
    lastPrice: json["last_price"].toDouble(),
    volume24: json["volume24"].toDouble(),
    volumeWeek: json["volumeWeek"].toDouble(),
    volumeMonth: json["volumeMonth"].toDouble(),
    change24: json["change24"].toDouble(),
    changeWeek: json["changeWeek"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "base_token": baseToken.toJson(),
    "quote_token": quoteToken.toJson(),
    "min_buy": minBuy,
    "min_sell": minSell,
    "fee": fee,
    "last_price": lastPrice,
    "volume24": volume24,
    "volumeWeek": volumeWeek,
    "volumeMonth": volumeMonth,
    "change24": change24,
    "changeWeek": changeWeek,
  };
}

class EToken {
  EToken({
    required this.contract,
    required this.symbol,
    required this.str,
  });

  String contract;
  Symbol symbol;
  String str;

  factory EToken.fromJson(Map<String, dynamic> json) => EToken(
    contract: json["contract"],
    symbol: Symbol.fromJson(json["symbol"]),
    str: json["str"],
  );

  Map<String, dynamic> toJson() => {
    "contract": contract,
    "symbol": symbol.toJson(),
    "str": str,
  };
}

class Symbol {
  Symbol({
    required this.name,
    required this.precision,
  });

  String name;
  int precision;

  factory Symbol.fromJson(Map<String, dynamic> json) => Symbol(
    name: json["name"],
    precision: json["precision"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "precision": precision,
  };
}
