import 'dart:async';
import 'dart:convert';

import 'package:currency_calculator/pojo/FwACBalanceResponse.dart';
import 'package:currency_calculator/pojo/alcormarket_response.dart';
import 'package:currency_calculator/pojo/api_response.dart';
import 'package:currency_calculator/pojo/fwToolsResponse.dart';
import 'package:currency_calculator/screens/settings.dart';
import 'package:currency_calculator/utilities/HexColorUtils.dart';
import 'package:currency_calculator/utilities/constant.dart';
import 'package:currency_calculator/utilities/converter.dart';
import 'package:currency_calculator/utilities/dev.log.dart';
import 'package:currency_calculator/utilities/strings.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class FWCards extends StatefulWidget {
  const FWCards({Key? key}) : super(key: key);

  @override
  _FWCardsState createState() => _FWCardsState();
}

class _FWCardsState extends State<FWCards> {
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

  double fwgChange24Hr = 0.0;
  double fwwChange24Hr = 0.0;
  double fwfChange24Hr = 0.0;

  double expenseFood = 96;
  double expenseWood = 41;
  double expenseGold = -38;
  int energy = 0;
  num maxEnergy = 0.0;

  late String accountId;

  late int templateId;

  Map<String, dynamic> fwToolsResponse = {};

  late int currentMills;

  bool isLoading = false;

  double fwgCurrentPriceINR = 0.0;

  double fwfCurrentPriceINR = 0.0;
  double fwwCurrentPriceINR = 0.0;

  double fwfTotalWax = 0.0;
  double fwgTotalWax = 0.0;
  double fwwTotalWax = 0.0;

  double fwfTotalInr = 0.0;
  double fwgTotalInr = 0.0;
  double fwwTotalInr = 0.0;

  double waxInUSD = 0.0;

  double waxInINR = 0.0;

  late Converter converter;

  static var maxRefreshTime = 120;

  late Timer _timer1Sec;
  late DateTime dateTime;

  late Timer refreshTimer;

  late double currentSeconds;

  double intervalCountdown = 0;
  int count = 0;

  // static var currentSeconds;

  // FwToolsResponse assetsMap;

  // late FwToolsResponse assetsMap;

  @override
  Widget build(BuildContext context) {
    currentSeconds = dateTime.second.toDouble();
    intervalCountdown = count.toDouble();
    return Scaffold(
        appBar: AppBar(
          title: Text("FWWorld"),
          actions: [
            !isLoading
                ? Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        _refreshData();
                      },
                      child: const Icon(
                        Icons.refresh,
                        size: 26.0,
                      ),
                    ))
                : const Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: Icon(
                      Icons.av_timer,
                      size: 26.0,
                    ),
                  ),
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Settings()),
                    );
                  },
                  child: const Icon(
                    Icons.settings,
                    size: 26.0,
                  ),
                ))
          ],
        ),
        body: Container(
          color: Colors.black12,
          child: ListView(
            children: [
              showMarketPrice(),
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
    converter = Converter();

    Dev.debug("getAllFarmersWorldData");

    dateTime = DateTime.now();
    _timer1Sec = Timer.periodic(const Duration(seconds: 1), setTime);
    refreshTimer = Timer.periodic(
        Duration(seconds: maxRefreshTime), refreshAlchorExchange);
    _refreshData();
  }

  void setTime(Timer timer) {
    count++;
    setState(() {
      dateTime = DateTime.now();
      intervalCountdown = count.toDouble();
    });
    // print('intervalCountdown $intervalCountdown');
  }

  _refreshData() {
    getWaxPrice();
    getAllFarmersWorldData();

    getCurrentStatus();
  }

  @override
  void dispose() {
    _timer1Sec.cancel();
    refreshTimer.cancel();

    super.dispose();
  }

  resourceList() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      height: 130.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          SizedBox(
            width: 140.0,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: const Color.fromARGB(255, 154, 33, 92),
              elevation: 10,
              child: Column(children: [
                ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/logo/wax.webp',
                      height: 28,
                      width: 28,
                    ),
                  ),
                  title: const Text('Wax',
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                  subtitle: const Text('WAXP',
                      style: TextStyle(color: Colors.white, fontSize: 11)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(waxInUSD.toStringAsFixed(3),
                        style: const TextStyle(color: Colors.white)),
                    const Text('\$', style: TextStyle(color: Colors.white)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(waxInINR.toStringAsFixed(2),
                        style: const TextStyle(color: Colors.white)),
                    const Text('₹', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ]),
            ),
          ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(fwgCurrentPrice.toStringAsFixed(3),
                        style: const TextStyle(color: Colors.white)),
                    Text('(${fwgChange24Hr.toStringAsFixed(2)})',
                        style: const TextStyle(color: Colors.white)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(fwgCurrentPriceINR.toStringAsFixed(2),
                        style: const TextStyle(color: Colors.white)),
                    const Text('₹', style: TextStyle(color: Colors.white)),
                  ],
                ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(fwfCurrentPrice.toStringAsFixed(3),
                        style: const TextStyle(color: Colors.white)),
                    Text('(${fwfChange24Hr.toStringAsFixed(2)})',
                        style: const TextStyle(color: Colors.white)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(fwfCurrentPriceINR.toStringAsFixed(2),
                        style: const TextStyle(color: Colors.white)),
                    const Text('₹', style: TextStyle(color: Colors.white)),
                  ],
                ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(fwwCurrentPrice.toStringAsFixed(3),
                        style: const TextStyle(color: Colors.white)),
                    Text('(${fwwChange24Hr.toStringAsFixed(2)})',
                        style: const TextStyle(color: Colors.white)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(fwwCurrentPriceINR.toStringAsFixed(2),
                        style: const TextStyle(color: Colors.white)),
                    const Text('₹', style: TextStyle(color: Colors.white)),
                  ],
                ),
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
        color: const Color.fromARGB(255, 58, 12, 163),
        elevation: 10,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text("     ",
                    style: TextStyle(color: Colors.white, fontSize: 14)),
                Text("InGame",
                    style: TextStyle(color: Colors.white, fontSize: 14)),
                Text("Wax",
                    style: TextStyle(color: Colors.white, fontSize: 14)),
                Text("INR",
                    style: TextStyle(color: Colors.white, fontSize: 14)),
                Text("Daily",
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
                Text(balanceFood.toStringAsFixed(2),
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
                Text(fwfTotalWax.toStringAsFixed(4),
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
                Text(fwfTotalInr.toStringAsFixed(2),
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
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
                Text(balanceWood.toStringAsFixed(2),
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
                Text(fwwTotalWax.toStringAsFixed(4),
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
                Text(fwwTotalInr.toStringAsFixed(2),
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
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
                Text(balanceGold.toStringAsFixed(2),
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
                Text(fwgTotalWax.toStringAsFixed(4),
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
                Text(fwgTotalInr.toStringAsFixed(2),
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
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
    Dev.info("getAllFarmersWorldData() called");
    isLoadingFwgPrice = true;
    isLoadingFwwPrice = true;
    isLoadingFwfPrice = true;
    Converter converter = Converter();
    Map<String, dynamic> fwgData = await getFWPrice(fwg_api);
    var fwgPrice = fwgData["lastPrice"];

    // await converter.getEstimatedAmountINR(dio, fwgPrice, "WAXP");
    // double fwgINR =
    double fwgINR =
        await converter.calculateTokenAmountINR(fwgPrice, waxInINR, "FWG");
    setState(() {
      fwgCurrentPrice = fwgPrice;
      fwgChange24Hr = fwgData["change24"];
      fwgCurrentPriceINR = fwgINR;
      isLoadingFwgPrice = false;
    });
    Map<String, dynamic> fwwData = await getFWPrice(fww_api);
    double fwwPrice = fwwData["lastPrice"];

    // await converter.getEstimatedAmountINR(dio, fwwPrice, "WAXP");
    double fwwINR =
        await converter.calculateTokenAmountINR(fwwPrice, waxInINR, "FWW");
    setState(() {
      fwwCurrentPrice = fwwPrice;
      fwwChange24Hr = fwwData["change24"];
      fwwCurrentPriceINR = fwwINR;
      isLoadingFwwPrice = false;
    });
    Map<String, dynamic> fwfData = await getFWPrice(fwf_api);
    double fwfPrice = fwfData["lastPrice"];

    // await converter.getEstimatedAmountINR(dio, fwfPrice, "WAXP");
    double fwfINR =
        await converter.calculateTokenAmountINR(fwfPrice, waxInINR, "FWF");

    setState(() {
      fwfCurrentPrice = fwfPrice;
      fwfChange24Hr = fwfData["change24"];
      fwfCurrentPriceINR = fwfINR;
      isLoadingFwfPrice = false;
      getInGameResourceBalance();
    });
    // startRefreshTimer();
  }

  Future<Map<String, dynamic>> getFWPrice(String api) async {
    Map<String, dynamic> dataMap = {};
    var header = {
      'Content-Type': 'application/json',
    };
    // var url = fwf_api;
    Dev.debug('getEstimatedAmount : $api');

    var response = await dio.get(api, options: Options(headers: header));
    var alcorResponse = AlcorMarketResponse.fromJson(response.data);
    Dev.info("response : ${alcorResponse.lastPrice}");
    if (alcorResponse.lastPrice != null) {
      dataMap["lastPrice"] = alcorResponse.lastPrice;
    } else {
      dataMap["lastPrice"] = 0.0;
    }
    if (alcorResponse.change24 != null) {
      dataMap["change24"] = alcorResponse.change24;
    } else {
      dataMap["change24"] = 0.0;
    }
    return dataMap;
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
        // var getdata = json.decode(response.body);
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

        double gold = double.parse(bGold);
        double wood = double.parse(bWood);
        double food = double.parse(bFood);

        setState(() {
          accountId = data.account;
          energy = data.energy;
          maxEnergy = data.maxEnergy;

          balanceGold = gold;
          balanceWood = wood;
          balanceFood = food;

          calculateAllTokens(
              gold: balanceGold, wood: balanceWood, food: balanceFood);
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
            'Error getCurrentStatus : statusCode : ${response.statusCode}');
      }
    } on TimeoutException catch (_) {
      Dev.debug('getCurrentStatus TimeOutException');
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
      // data.rows.forEach((element) {})
      for (var element in data.rows) {
        // print('assetMap ${assetTemplateMapping[element.templateId.toString()]}');
        mCard.add(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: const Color.fromARGB(255, 63, 55, 201),
              elevation: 10,
              child: SizedBox(
                height: 180,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Table(
                        columnWidths: const <int, TableColumnWidth>{
                          0: FixedColumnWidth(80),
                          1: FixedColumnWidth(110),
                        },
                        defaultColumnWidth: const IntrinsicColumnWidth(),
                        children: [
                          TableRow(
                              children: createDataRowDateTime(
                                  "Time", element.nextAvailability)),
                          TableRow(
                            children: createDuribality(
                                "Durability",
                                element.currentDurability.toString(),
                                element.durability.toString()),
                          ),
                          TableRow(
                            children: createDataRow(
                                "Templet", element.templateId.toString()),
                          ),
                          TableRow(
                            children: createDataRow("Owner", element.owner),
                          ),
                          TableRow(
                            children: createDataRow("Type", element.type),
                          ),
                          TableRow(
                            children:
                                createDataRow("Asset ID", element.assetId),
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      assetTemplateMapping[element.templateId.toString()],
                      height: 120,
                      width: 130,
                    ),
                  ],
                ),
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
    List<TableCell> child = [];
    child.add(TableCell(
        child: SizedBox(
            height: 25,
            child: Text(label,
                style: const TextStyle(color: Colors.white, fontSize: 14)))));

    child.add(
      TableCell(
          child: SizedBox(
              height: 25,
              child: Text(value,
                  style: const TextStyle(color: Colors.white, fontSize: 14)))),
    );
    return child;
  }

  // updateCurrentTime() {
  //   setState(() {
  //     currentMills = DateTime.now().millisecondsSinceEpoch;
  //     currentSeconds = DateTime.now().second;
  //   });
  //   print(currentMills);
  //   print(currentSeconds);
  // }

  createDataRowDateTime(String label, int nextAvailability) {
    DateTime dt1 = DateTime.fromMillisecondsSinceEpoch(nextAvailability * 1000);

    DateTime dt2 = DateTime.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch);

    var output = DateFormat('dd/MM/yyyy, HH:mm').format(dt1);
    var output2 = DateFormat('dd/MM/yyyy, HH:mm').format(dt2);

    Duration diff = dt1.difference(dt2);

    String dur = diff.toString();
    var durArr = dur.split(':');

    var durationLeft =
        durArr[0] + ":" + durArr[1] + ":" + durArr[2].split('.')[0];

    List<TableCell> child = [];
    child.add(TableCell(
        child: SizedBox(
      height: 25,
      child: Text(label,
          style: const TextStyle(color: Colors.white, fontSize: 14)),
    )));

    child.add(
      TableCell(
        child: SizedBox(
          height: 25,
          child: Text(durationLeft,
              style: const TextStyle(color: Colors.white, fontSize: 14)),
        ),
      ),
    );
    return child;
  }

  createDuribality(String label, String current, String total) {
    List<TableCell> child = [];
    child.add(TableCell(
        child: SizedBox(
            height: 25,
            child: Text(label,
                style: const TextStyle(color: Colors.white, fontSize: 14)))));

    child.add(TableCell(
      child: SizedBox(
          height: 25,
          child: Text('$current/$total',
              style: const TextStyle(color: Colors.white, fontSize: 14))),
    ));
    return child;
  }

  showMarketPrice() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.0),
          ),
          color: const Color.fromARGB(255, 63, 55, 201),
          elevation: 10,
          child: sleekCircularSlider(),
        ));
  }

  SleekCircularSlider sleekCircularSlider() {
    return SleekCircularSlider(
      appearance: CircularSliderAppearance(
          customWidths: CustomSliderWidths(
              trackWidth: 1, progressBarWidth: 2, shadowWidth: 0),
          customColors: CustomSliderColors(
              dotColor: Colors.white.withOpacity(0.8),
              trackColor: HexColor('#FFD4BE').withOpacity(0.4),
              progressBarColor: HexColor('#F6A881'),
              shadowColor: HexColor('#FFD4BE'),
              shadowStep: 3.0,
              shadowMaxOpacity: 0.6),
          startAngle: 270,
          angleRange: 360,
          size: 20.0,
          animationEnabled: false),
      min: 0,
      max: maxRefreshTime.toDouble(),
      initialValue: intervalCountdown,
      // onChangeEnd: refresStatus(),
    );
  }

  void getWaxPrice() async {
    waxInINR = await converter.getEstimatedAmountINR(dio, 1, 'WAXP');
    waxInUSD = await converter.getEstimatedAmountUSD(dio, 1, 'WAXP');
  }

  calculateAllTokens({gold, wood, food}) {
    double fwfTotalW = converter.gameTokenToWax(fwfCurrentPrice, food);
    double fwgTotalW = converter.gameTokenToWax(fwgCurrentPrice, gold);
    double fwwTotalW = converter.gameTokenToWax(fwwCurrentPrice, wood);

    double fwfWaxTotInr = converter.waxToINR(fwfTotalW, waxInINR);
    double fwgWaxTotInr = converter.waxToINR(fwgTotalW, waxInINR);
    double fwwWaxTotInr = converter.waxToINR(fwwTotalW, waxInINR);
    print(
        "CalculateAllTokens fwfTotalW $fwfTotalW fwgCurrentPrice $fwgCurrentPrice, gold $gold");
    print(
        "CalculateAllTokens fwgTotalW $fwgTotalW fwfCurrentPrice $fwfCurrentPrice, gold $food");
    print(
        "CalculateAllTokens fwwTotalW $fwwTotalW fwwCurrentPrice $fwwCurrentPrice, gold $wood");

    setState(() {
      fwfTotalWax = fwfTotalW;
      fwgTotalWax = fwgTotalW;
      fwwTotalWax = fwwTotalW;
      fwfTotalInr = fwfWaxTotInr;
      fwgTotalInr = fwgWaxTotInr;
      fwwTotalInr = fwwWaxTotInr;
      print(
          "CalculateAllTokens $gold, $wood,$food, == $fwwTotalWax ,$fwgTotalWax ,$fwfTotalWax ");
    });
  }

  getTimerSlider() {
    return SleekCircularSlider(
      appearance: CircularSliderAppearance(
          customWidths: CustomSliderWidths(
              trackWidth: 2, progressBarWidth: 10, shadowWidth: 20),
          customColors: CustomSliderColors(
              dotColor: Colors.white.withOpacity(0.8),
              trackColor: HexColor('#FFD4BE').withOpacity(0.4),
              progressBarColor: HexColor('#F6A881'),
              shadowColor: HexColor('#FFD4BE'),
              shadowStep: 10.0,
              shadowMaxOpacity: 0.6),
          startAngle: 270,
          angleRange: 360,
          size: 100.0,
          animationEnabled: false),
      min: 0,
      max: maxRefreshTime.toDouble(),
      initialValue: intervalCountdown,
      // innerWidget: (double value) {
      //   final s = currentSeconds.toInt() < 10
      //       ? '0${currentSeconds.toInt()}'
      //       : currentSeconds.toInt().toString();
      //   return Center(
      //       child: Text(
      //     ' $s',
      //     style: TextStyle(
      //         color: HexColor('#A177B0'),
      //         fontSize: 20,
      //         fontWeight: FontWeight.w400),
      //   ));
      // },
    );
  }

  void refreshAlchorExchange(Timer timer) {
    setState(() {
      count = 0;
    });

    Dev.info("refresStatus()");
    getAllFarmersWorldData();
  }
}
