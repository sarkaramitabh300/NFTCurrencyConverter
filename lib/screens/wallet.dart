import 'dart:async';
import 'dart:convert';

import 'package:currency_calculator/pojo/CoinToINR.dart';
import 'package:currency_calculator/pojo/walletBalanceResponse.dart';
import 'package:currency_calculator/utilities/dev.log.dart';
import 'package:currency_calculator/utilities/strings.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Wallet extends StatefulWidget {
  const Wallet({Key? key}) : super(key: key);

  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  bool isLoading = false;

  bool isWalletBalanceLoading = false;

  late Balance fwfList;

  late Balance fwgList;

  late Balance fwwList;

  late Balance waxList;

  bool isLoadingCryptoPriceINR = false;

  var dio;

  double waxToInr = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wallet"),
        actions: [
          isLoading
              ? const Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: Icon(
                    Icons.av_timer,
                    size: 26.0,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      _refreshData();
                    },
                    child: const Icon(
                      Icons.refresh,
                      size: 26.0,
                    ),
                  ),
                )
        ],
      ),
      body: Container(
        color: Colors.black12,
        child: SingleChildScrollView(
          child: Column(
            children: [walletFundCard()],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    dio = Dio();
    _refreshData();
    super.initState();
  }

  void _refreshData() {
    getWalletBalance();
  }

  walletFundCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: const Color.fromARGB(255, 63, 55, 201),
        elevation: 10,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text("Currency  ",
                    style: TextStyle(color: Colors.white, fontSize: 14)),
                SizedBox(
                  width: 10,
                ),
                Text("Token   ",
                    style: TextStyle(color: Colors.white, fontSize: 14)),
                SizedBox(
                  width: 70,
                ),
                Text("Wax  ",
                    style: TextStyle(color: Colors.white, fontSize: 14)),
                SizedBox(
                  width: 40,
                ),
                Text("INR",
                    style: TextStyle(color: Colors.white, fontSize: 14)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/logo/wax.webp',
                  height: 28,
                  width: 28,
                ),
                Text(waxList != null ? waxList.currency : '',
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
                const SizedBox(
                  width: 70,
                ),
                Wrap(children: [
                  Text(
                      waxList != null
                          ? double.parse(waxList.amount)
                              .toStringAsFixed(int.parse(waxList.decimals))
                          : '',
                      style:
                          const TextStyle(color: Colors.white, fontSize: 14)),
                ]),
                const SizedBox(
                  width: 40,
                ),
                Text(waxToInr.toStringAsFixed(2),
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/logo/FWF2.png',
                  height: 28,
                  width: 28,
                ),
                Text(fwfList != null ? fwfList.currency : '',
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
                const SizedBox(
                  width: 10,
                ),
                Text(
                    fwfList != null
                        ? double.parse(fwfList.amount)
                            .toStringAsFixed(int.parse(fwfList.decimals))
                        : '',
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
                const SizedBox(
                  width: 60,
                ),
                const Text('',
                    style: TextStyle(color: Colors.white, fontSize: 14)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/logo/FWG2.png',
                  height: 28,
                  width: 28,
                ),
                Text(fwgList != null ? fwgList.currency : '',
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
                const SizedBox(
                  width: 10,
                ),
                Text(
                    fwgList != null
                        ? double.parse(fwgList.amount)
                            .toStringAsFixed(int.parse(fwgList.decimals))
                        : '',
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
                const SizedBox(
                  width: 60,
                ),
                Text('',
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/logo/FWW2.png',
                  height: 28,
                  width: 28,
                ),
                Text(fwwList != null ? fwwList.currency : '',
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
                const SizedBox(
                  width: 10,
                ),
                Text(
                    fwwList != null
                        ? double.parse(fwwList.amount)
                            .toStringAsFixed(int.parse(fwwList.decimals))
                        : '',
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
                const SizedBox(
                  width: 60,
                ),
                const Text('',
                    style: TextStyle(color: Colors.white, fontSize: 14)),
              ],
            ),
          )
        ]),
      ),
    );
  }

  Future<void> getWalletBalance() async {
    setState(() {
      isWalletBalanceLoading = true;
    });
    Map<String, String> headersType = {
      'Content-Type': 'application/json',
    };
    // var url = fwf_api;
    Dev.debug('getWalletBalance : $waxAcc_api');
    try {
      var response = await get(Uri.parse(waxAcc_api), headers: headersType)
          .timeout(const Duration(seconds: 2000));

      setState(() {
        isWalletBalanceLoading = false;
      });

      if (response.statusCode == 200) {
        var getdata = json.decode(response.body);
        WalletBalance apiResponse =
            WalletBalance.fromJson(json.decode(response.body));

        Dev.debug("getWalletBalance ${json.decode(response.body)}");

        apiResponse.balances.forEach((element) async {
          if (element.currency == 'FWF') {
            fwfList = element;
          } else if (element.currency == 'FWG') {
            fwgList = element;
          } else if (element.currency == 'FWW') {
            fwwList = element;
          } else if (element.currency == 'WAX') {
            waxList = element;
            waxToInr = await getEstimatedAmountINR(
                double.parse(element.amount), 'WAXP');
          }
        });
      } else {
        Dev.debug(
            'Error getWalletBalance : statusCode : ${response.statusCode}');
      }
    } on TimeoutException catch (_) {
      setState(() {
        isWalletBalanceLoading = false;
      });
      Dev.debug('Error: getWalletBalance TimeOutException');
    } catch (e) {
      setState(() {
        isWalletBalanceLoading = false;
      });
      Dev.debug('Error: getWalletBalance TimeOutException');
    }
  }

  getEstimatedAmountINR(double unpaidEth, String fromCurrency) async {
    isLoadingCryptoPriceINR = true;
    var params = {
      'amount': unpaidEth,
      'symbol': fromCurrency,
      'convert': "INR"
    };
    var header = {
      'Content-Type': 'application/json',
      'X-CMC_PRO_API_KEY': '60107775-bc9f-48f8-8c5f-59556ccd0583',
      'Accept-Encoding': 'deflate, gzip'
    };
    var url = 'https://pro-api.coinmarketcap.com/v1/tools/price-conversion';
    Dev.debug('getEstimatedAmountINR URL: $url');
    Dev.debug('getEstimatedAmountINR params : $params');
    try {
      isLoadingCryptoPriceINR = false;
      var response = await dio.get(url,
          options: Options(headers: header), queryParameters: params);
      var myData = CoinToInr.fromJson(response.data);
      // print('hh ${myData.data.amount}');
      // print('hh ${myData.data.quote}');
      print('hh ${myData.data.quote.inr.price}');
      // print('hh ${myData.data.id}');
      // print('hh ${myData.data.name}');
      // print('hh ${myData.data.symbol}');
      // print('hh ${myData.data.lastUpdated}');
      return myData.data.quote.inr.price;
    } on DioError catch (e) {
      isLoadingCryptoPriceINR = false;
      if (e.type == DioErrorType.response) {
        print('catched ${e.message} ${e.stackTrace}');
        print('catched ${e.stackTrace}');
        print('catched ${e.error}');
        print('catched ${e.type}');
        return;
      }
      if (e.type == DioErrorType.connectTimeout) {
        print('check your connection');
        return;
      }

      if (e.type == DioErrorType.receiveTimeout) {
        print('unable to connect to the server');
        return;
      }

      if (e.type == DioErrorType.other) {
        print('Something went wrong');
        return;
      }
      print(e);
      return 0.0;
    } catch (e) {
      isLoadingCryptoPriceINR = false;
      print(e);
      return 0.0;
    }
  }
}
