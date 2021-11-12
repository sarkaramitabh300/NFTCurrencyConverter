// To parse this JSON data, do
//
//     final walletBalance = walletBalanceFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

WalletBalance walletBalanceFromJson(String str) =>
    WalletBalance.fromJson(json.decode(str));

String walletBalanceToJson(WalletBalance data) => json.encode(data.toJson());

class WalletBalance {
  WalletBalance({
    required this.chain,
    required this.balances,
    required this.accountName,
  });

  Chain chain;
  List<Balance> balances;
  String accountName;

  factory WalletBalance.fromJson(Map<String, dynamic> json) => WalletBalance(
        chain: Chain.fromJson(json["chain"]),
        balances: List<Balance>.from(
            json["balances"].map((x) => Balance.fromJson(x))),
        accountName: json["account_name"],
      );

  Map<String, dynamic> toJson() => {
        "chain": chain.toJson(),
        "balances": List<dynamic>.from(balances.map((x) => x.toJson())),
        "account_name": accountName,
      };
}

class Balance {
  Balance({
    required this.contract,
    required this.decimals,
    required this.currency,
    required this.amount,
  });

  String contract;
  String decimals;
  String currency;
  String amount;

  factory Balance.fromJson(Map<String, dynamic> json) => Balance(
        contract: json["contract"],
        decimals: json["decimals"],
        currency: json["currency"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "contract": contract,
        "decimals": decimals,
        "currency": currency,
        "amount": amount,
      };
}

class Chain {
  Chain({
    required this.rexEnabled,
    required this.systoken,
    required this.sync,
    required this.production,
    required this.blockNum,
    required this.network,
    required this.blockTime,
    required this.description,
    required this.chainid,
    required this.decimals,
  });

  int rexEnabled;
  String systoken;
  int sync;
  int production;
  int blockNum;
  String network;
  DateTime blockTime;
  String description;
  String chainid;
  int decimals;

  factory Chain.fromJson(Map<String, dynamic> json) => Chain(
        rexEnabled: json["rex_enabled"],
        systoken: json["systoken"],
        sync: json["sync"],
        production: json["production"],
        blockNum: json["block_num"],
        network: json["network"],
        blockTime: DateTime.parse(json["block_time"]),
        description: json["description"],
        chainid: json["chainid"],
        decimals: json["decimals"],
      );

  Map<String, dynamic> toJson() => {
        "rex_enabled": rexEnabled,
        "systoken": systoken,
        "sync": sync,
        "production": production,
        "block_num": blockNum,
        "network": network,
        "block_time": blockTime.toIso8601String(),
        "description": description,
        "chainid": chainid,
        "decimals": decimals,
      };
}
