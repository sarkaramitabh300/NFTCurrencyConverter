import 'dart:async';
import 'dart:convert';

import 'package:currency_calculator/pojo/FwACBalanceResponse.dart';
import 'package:currency_calculator/pojo/alcormarket_response.dart';
import 'package:currency_calculator/pojo/api_response.dart';
import 'package:currency_calculator/pojo/fwToolsResponse.dart';
import 'package:currency_calculator/utilities/constant.dart';
import 'package:currency_calculator/utilities/dev.log.dart';
import 'package:currency_calculator/utilities/strings.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class FWCards extends StatefulWidget {
  const FWCards({Key? key}) : super(key: key);

  @override
  _FWCardsState createState() => _FWCardsState();
}

class _FWCardsState extends State<FWCards> {
  Timer? timer;
  var dio;
  double fwgCurrentPrice = 0.0;

  double fwwCurrentPrice = 0.0;
  double fwfCurrentPrice = 0.0;
  bool isLoadingFwgPrice = false;

  bool isLoadingFwwPrice = false;

  bool isLoadingFwfPrice = false;

  double balanceFood = 0.0;
  double balanceWood = 0.0;
  double balanceGold = 0.0;

  double expenseFood = 96;
  double expenseWood = 41;
  double expenseGold = -38;
  int energy = 0;
  num maxEnergy = 0.0;

  late String accountId;

  late int templateId;

  Map<String, dynamic> fwToolsResponse = {};

  late int currentMills;

  // FwToolsResponse assetsMap;

  // late FwToolsResponse assetsMap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          color: Colors.black12,
          child: ListView(
            children: [
              resourceList(),
              gameAccountBalance(),
              showAssetsStatus()
            ],
          ),
        ));
  }

  @override
  void initState() {
    dio = Dio();
    getAllFarmersWorldData();
    getInGameResourceBalance();
    getCurrentStatus();
    Dev.debug("getAllFarmersWorldData");
    timer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => updateCurrentTime());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  resourceList() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      height: 100.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          SizedBox(
            width: 140.0,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: const Color.fromARGB(255, 181, 23, 158),
              elevation: 10,
              child: Column(children: [
                ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/logo/fwg_farmerstoken.png',
                      height: 28,
                      width: 28,
                    ),
                  ),
                  title: const Text('Gold',
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                  subtitle: const Text('FWG',
                      style: TextStyle(color: Colors.white, fontSize: 11)),
                ),
                Text(fwgCurrentPrice.toStringAsFixed(3),
                    style: const TextStyle(color: Colors.white)),
              ]),
            ),
          ),
          SizedBox(
            width: 140.0,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: const Color.fromARGB(255, 114, 9, 183),
              elevation: 10,
              child: Column(children: [
                ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/logo/fwf_farmerstoken.png',
                      height: 28,
                      width: 28,
                    ),
                  ),
                  title: const Text('Food',
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                  subtitle: const Text('FWF',
                      style: TextStyle(color: Colors.white, fontSize: 11)),
                ),
                Text(fwfCurrentPrice.toStringAsFixed(3),
                    style: const TextStyle(color: Colors.white)),
              ]),
            ),
          ),
          SizedBox(
            width: 140.0,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: const Color.fromARGB(255, 95, 13, 123),
              elevation: 10,
              child: Column(children: [
                ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Image.asset(
                      'assets/logo/fww_farmerstoken.png',
                      height: 28,
                      width: 28,
                    ),
                  ),
                  title: const Text('Wood',
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                  subtitle: const Text('FWW',
                      style: TextStyle(color: Colors.white, fontSize: 11)),
                ),
                Text(fwwCurrentPrice.toStringAsFixed(3),
                    style: const TextStyle(color: Colors.white)),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  gameAccountBalance() {
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text("Token",
                    style: TextStyle(color: Colors.white, fontSize: 14)),
                SizedBox(
                  width: 50,
                ),
                Text("InGame Balance",
                    style: TextStyle(color: Colors.white, fontSize: 14)),
                SizedBox(
                  width: 50,
                ),
                Text("DailyExpanse",
                    style: TextStyle(color: Colors.white, fontSize: 14)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset(
                  'assets/logo/FWF2.png',
                  height: 28,
                  width: 28,
                ),
                const SizedBox(
                  width: 50,
                ),
                Text(balanceFood.toStringAsFixed(2),
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
                const SizedBox(
                  width: 50,
                ),
                Text(expenseFood.toStringAsFixed(2),
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset(
                  'assets/logo/FWW2.png',
                  height: 28,
                  width: 28,
                ),
                const SizedBox(
                  width: 50,
                ),
                Text(balanceWood.toStringAsFixed(2),
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
                const SizedBox(
                  width: 50,
                ),
                Text(expenseWood.toStringAsFixed(2),
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset(
                  'assets/logo/FWG2.png',
                  height: 28,
                  width: 28,
                ),
                const SizedBox(
                  width: 50,
                ),
                Text(balanceGold.toStringAsFixed(2),
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
                const SizedBox(
                  width: 50,
                ),
                Text(expenseGold.toStringAsFixed(2),
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
              ],
            ),
          )
        ]),
      ),
    );
  }

  Future<void> getAllFarmersWorldData() async {
    isLoadingFwgPrice = true;
    isLoadingFwwPrice = true;
    isLoadingFwfPrice = true;

    double fwgPrice = await getFWPrice(fwg_api);
    setState(() {
      fwgCurrentPrice = fwgPrice;
      isLoadingFwgPrice = false;
    });
    double fwwPrice = await getFWPrice(fww_api);
    setState(() {
      fwwCurrentPrice = fwwPrice;
      isLoadingFwwPrice = false;
    });
    double fwfPrice = await getFWPrice(fwf_api);
    setState(() {
      fwfCurrentPrice = fwfPrice;
      isLoadingFwfPrice = false;
    });
  }

  Future<double> getFWPrice(String api) async {
    var header = {
      'Content-Type': 'application/json',
    };
    // var url = fwf_api;
    Dev.debug('getEstimatedAmount : $api');

    var response = await dio.get(api, options: Options(headers: header));
    var alcorResponse = AlcorMarketResponse.fromJson(response.data);
    Dev.info("response : ${alcorResponse.lastPrice}");
    if (alcorResponse.lastPrice != null) {
      return alcorResponse.lastPrice;
    } else {
      return 0.0;
    }
  }

  void getInGameResourceBalance() async {
    Map<String, String> headersType = {
      'Content-Type': 'application/json',
    };
    // var url = fwf_api;
    Dev.debug('getInGameResourceBalance : $fwf12_base_api');
    try {
      var response = await post(Uri.parse(fwf12_base_api),
              body: jsonEncode(fw_ac_balance_body), headers: headersType)
          .timeout(const Duration(seconds: 2000));
      if (response.statusCode == 200) {
        var getdata = json.decode(response.body);
        FwAcBalanceResponse apiResponse =
            FwAcBalanceResponse.fromJson(json.decode(response.body));

        Dev.debug("getInGameResourceBalance ${json.decode(response.body)}");
        var data = apiResponse.rows.first;
        accountId = data.account;
        energy = data.energy;
        maxEnergy = data.maxEnergy;
        String bGold = data.balances[0].split(' ').first;
        String bWood = data.balances[1].split(' ').first;
        String bFood = data.balances[2].split(' ').first;
        setState(() {
          accountId = data.account;
          energy = data.energy;
          maxEnergy = data.maxEnergy;
          balanceGold = double.parse(bGold);
          balanceWood = double.parse(bWood);
          balanceFood = double.parse(bFood);
        });
      } else {
        Dev.debug(
            'Error getInGameResourceBalance : statusCode : ${response.statusCode}');
      }
    } on TimeoutException catch (_) {
      Dev.debug('getInGameResourceBalance TimeOutException');
    }
  }

  void getCurrentStatus() async {
    Map<String, String> headersType = {
      'Content-Type': 'application/json',
    };

    Dev.debug('getCurrentStatus : $fwf12_base_api');
    try {
      var response = await post(Uri.parse(fwf12_base_api),
              body: jsonEncode(fw_ac_tools_body), headers: headersType)
          .timeout(const Duration(seconds: 2000));
      if (response.statusCode == 200) {
        setState(() {
          fwToolsResponse = json.decode(response.body);
        });

        Dev.debug("getCurrentStatus ${json.decode(response.body)}");
      } else {
        Dev.debug(
            'Error getInGameResourceBalance : statusCode : ${response.statusCode}');
      }
    } on TimeoutException catch (_) {
      Dev.debug('getInGameResourceBalance TimeOutException');
    }
  }

  showAssetsStatus() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: getAssetList(),
    );
  }

  getAssetList() {
    List<Widget> mCard = [];
    if (fwToolsResponse.length > 1) {
      var data = FwToolsResponse.fromJson(fwToolsResponse);

      for (var element in data.rows) {
        // print('assetMap ${assetTemplateMapping[element.templateId.toString()]}');
        mCard.add(
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: const Color.fromARGB(255, 63, 55, 201),
            elevation: 10,
            child: SizedBox(
              height: 130,
              child: Row(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                            children: createDataRowDateTime(
                                "Time", element.nextAvailability)),
                        Row(
                          children: createDuribality(
                              "Durability",
                              element.currentDurability.toString(),
                              element.durability.toString()),
                        ),
                        Row(
                          children: createDataRow(
                              "Templet", element.templateId.toString()),
                        ),
                        Row(
                          children: createDataRow("Owner", element.owner),
                        ),
                        Row(
                          children: createDataRow("Type", element.type),
                        ),
                        Row(
                          children: createDataRow("Asset ID", element.assetId),
                        )
                      ],
                    ),
                  ),
                  Image.asset(
                    assetTemplateMapping[element.templateId.toString()],
                    height: 100,
                    width: 130,
                  ),
                ],
              ),
            ),
          ),
        );
      }
    } else {
      mCard.add(Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: const Color.fromARGB(255, 63, 55, 201),
              elevation: 10,
              child: Row(children: []))));
    }
    return mCard;
  }

  createDataRow(String label, String value) {
    List<Widget> child = [];
    child.add(
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)));
    child.add(const SizedBox(
      width: 60,
    ));
    child.add(
      Text(value, style: const TextStyle(color: Colors.white, fontSize: 14)),
    );
    return child;
  }

  updateCurrentTime() {
    setState(() {
      currentMills = DateTime.now().millisecondsSinceEpoch;
    });
    print(currentMills);
  }

  createDataRowDateTime(String label, int nextAvailability) {
    DateTime dt1 = DateTime.fromMillisecondsSinceEpoch(nextAvailability * 1000);

    DateTime dt2 = DateTime.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch);

    var output = DateFormat('dd/MM/yyyy, HH:mm').format(dt1);
    var output2 = DateFormat('dd/MM/yyyy, HH:mm').format(dt2);

    Duration diff = dt1.difference(dt2);

    String dur = diff.toString();
    var durArr = dur.split(':');

    // print('--------------');
    // print("hrs ${durArr[0]}");
    // print("min ${durArr[1]}");
    // print("sec ${durArr[2]}");
    // print(diff);
    var durationLeft =
        durArr[0] + ":" + durArr[1] + ":" + durArr[2].split('.')[0];

    List<Widget> child = [];
    child.add(
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)));
    child.add(const SizedBox(
      width: 60,
    ));
    child.add(
      Text(durationLeft,
          style: const TextStyle(color: Colors.white, fontSize: 14)),
    );
    return child;
  }

  createDuribality(String label, String current, String total) {
    List<Widget> child = [];
    child.add(
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)));
    child.add(const SizedBox(
      width: 60,
    ));
    child.add(
      Text('$current/$total',
          style: const TextStyle(color: Colors.white, fontSize: 14)),
    );
    return child;
  }
}
