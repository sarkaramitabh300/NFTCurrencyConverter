import 'dart:convert';
import 'package:currency_calculator/pojo/CoinToINR.dart';
import 'package:currency_calculator/pojo/CoinToUSD.dart';
import 'package:currency_calculator/pojo/alcormarket_response.dart';
import 'package:currency_calculator/pojo/curencry_converter_response.dart';
import 'package:currency_calculator/utilities/strings.dart';
import 'package:dio/dio.dart';
import 'package:currency_calculator/utilities/dev.log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String INR_UNIT = "INR";
  var dio;
  String USD_UNIT = "USD";
  final _formKey = GlobalKey<FormBuilderState>();

  var coinOptions = ["BTC", "ETH", "WAXP"];

  var currencyOptions = ["INR", "USD"];

  String convertedPriceINR = "45.89";

  String convertedPriceUSD = "45.89";

  double estimatedAmount = 0.0;

  double currentINRPrice = 0.0;

  String calculatedPrice = "0.0";

  String convertedUnit = "";

  double fwgPrice = 0.0;

  double fwwPrice = 0.0;
  double fwfPrice = 0.0;

  @override
  void initState() {
    dio = Dio();
    getUsdToINR();
    getAllFarmersWorldData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: bodyUI(),
    );
  }

  bodyUI() {
    return ListView(
      children: [
        Center(
          child: Column(
            children: [
              FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      cryptoConverter(),
                      currencyConverter(),
                      resourceList()
                    ],
                  )),
            ],
          ),
        ),
      ],
    );
  }

  void _onChanged(String? value) {
    Dev.debug(value);
  }

  fetchCryptoData() {
    // getEstimatedAmount(1.00, 2781);
    Dev.debug(_formKey.currentState!.value);
    Map<String, dynamic> data = _formKey.currentState!.value;
    Dev.debug(data['qty']);
    Dev.debug(data['coin']);
    getUsdToINR();
    getEstimatedAmountINR(double.parse(data['qty']), data['coin']);
    getEstimatedAmountUSD(double.parse(data['qty']), data['coin']);
  }

  getUsdToINR() {
    var params = {'amount': 1, 'symbol': "USD", 'convert': "INR"};
    var header = {
      'Content-Type': 'application/json',
      'X-CMC_PRO_API_KEY': '60107775-bc9f-48f8-8c5f-59556ccd0583',
      'Accept-Encoding': 'deflate, gzip'
    };
    var url = 'https://pro-api.coinmarketcap.com/v1/tools/price-conversion';
    Dev.debug('getEstimatedAmount : $url');
    Dev.debug('params : $params');
    dio
        .get(url, options: Options(headers: header), queryParameters: params)
        .then((response) {
      var currencyResponse = CoinToInr.fromJson(response.data);

      setState(() {
        currentINRPrice = currencyResponse.data.quote.inr.price;
      });
      Dev.debug(currencyResponse.data.quote.inr.price);
    });
    // .catchError((error) => handleHttpError(error));
  }

  getEstimatedAmountINR(double unpaidEth, String fromCurrency) {
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
    Dev.debug('getEstimatedAmount : $url');
    Dev.debug('params : $params');
    dio
        .get(url, options: Options(headers: header), queryParameters: params)
        .then((response) {
      var currencyResponse = CoinToInr.fromJson(response.data);

      setState(() {
        convertedPriceINR =
            currencyResponse.data.quote.inr.price.toStringAsFixed(2);
      });
      Dev.debug(currencyResponse.data.quote.inr.price);
    });
    // .catchError((error) => handleHttpError(error));
  }

  getEstimatedAmountUSD(double unpaidEth, String fromCurrency) {
    var params = {
      'amount': unpaidEth,
      'symbol': fromCurrency,
      'convert': "USD"
    };
    var header = {
      'Content-Type': 'application/json',
      'X-CMC_PRO_API_KEY': '60107775-bc9f-48f8-8c5f-59556ccd0583',
      'Accept-Encoding': 'deflate, gzip'
    };
    var url = 'https://pro-api.coinmarketcap.com/v1/tools/price-conversion';
    Dev.debug('getEstimatedAmount : $url');
    Dev.debug('params : $params');
    dio
        .get(url, options: Options(headers: header), queryParameters: params)
        .then((response) {
      var currencyResponse = CoinToUsd.fromJson(response.data);

      setState(() {
        convertedPriceUSD =
            currencyResponse.data.quote.usd.price.toStringAsFixed(2);
      });
      Dev.debug(currencyResponse.data.quote.usd.price);
    });
    // .catchError((error) => handleHttpError(error));
  }

  handleHttpError(DioError error) {
    Dev.debug('handleHttpError: message ${error.message}.');
    Dev.debug('handleHttpError: error ${error.error}.');
    Dev.debug('handleHttpError:  $error.');
  }

  cryptoConverter() {
    return Container(
      // height: 200,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: const Color.fromARGB(255, 63, 55, 201),
          elevation: 10,
          child: Column(children: [
            ListTile(
              // leading: Icon(Icons.album, size: 70),
              title: Text('1 USD = ${currentINRPrice.toStringAsFixed(2)} INR',
                  style: const TextStyle(color: Colors.white)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 100,
                  child: FormBuilderDropdown(
                    name: 'coin',
                    decoration: const InputDecoration(
                        labelText: 'Coin',
                        labelStyle: TextStyle(color: Colors.white)),
                    initialValue: coinOptions.first,
                    allowClear: false,
                    hint: const Text('Select',
                        style: TextStyle(color: Colors.white)),
                    dropdownColor: const Color.fromARGB(255, 181, 23, 158),
                    validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required(context)]),
                    items: coinOptions
                        .map((coin) => DropdownMenuItem(
                              value: coin,
                              child: Text(coin,
                                  style: const TextStyle(color: Colors.white)),
                            ))
                        .toList(),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: FormBuilderTextField(
                    name: 'qty',
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    initialValue: "1",

                    onChanged: _onChanged,
                    style: const TextStyle(color: Colors.white),
                    // valueTransformer: (text) => num.tryParse(text),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context),
                      FormBuilderValidators.numeric(context),
                    ]),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(convertedPriceUSD,
                    style: const TextStyle(color: Colors.white)),
                SizedBox(
                  width: 2,
                ),
                Text(USD_UNIT, style: const TextStyle(color: Colors.white)),
                const SizedBox(
                  width: 100,
                ),
                Text(convertedPriceINR,
                    style: const TextStyle(color: Colors.white)),
                SizedBox(
                  width: 2,
                ),
                Text(INR_UNIT, style: const TextStyle(color: Colors.white)),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 100,
                  child: MaterialButton(
                    color: Color.fromARGB(255, 67, 97, 238),
                    child: const Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      _formKey.currentState!.save();
                      if (_formKey.currentState!.validate()) {
                        Dev.debug(_formKey.currentState!.value);
                        fetchCryptoData();
                      } else {
                        Dev.debug("validation failed");
                      }
                    },
                  ),
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }

  currencyConverter() {
    return Container(
      // height: 200,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: const Color.fromARGB(255, 58, 12, 163),
          elevation: 10,
          child: Column(children: [
            ListTile(
              // leading: Icon(Icons.album, size: 70),
              title: Text('1 USD = ${currentINRPrice.toStringAsFixed(2)} INR',
                  style: const TextStyle(color: Colors.white)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  child: FormBuilderTextField(
                    name: 'currencyQty',

                    decoration: const InputDecoration(
                      labelText: ' ',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    initialValue: "1",
                    style: const TextStyle(color: Colors.white),
                    onChanged: _onChanged,
                    // valueTransformer: (text) => num.tryParse(text),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context),
                      FormBuilderValidators.numeric(context),
                    ]),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: FormBuilderDropdown(
                    name: 'currency',
                    decoration: const InputDecoration(
                      labelText: 'Currency',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                    initialValue: currencyOptions.first,
                    allowClear: false,
                    hint: const Text('Select',
                        style: const TextStyle(color: Colors.white)),
                    validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required(context)]),
                    items: currencyOptions
                        .map((currency) => DropdownMenuItem(
                              value: currency,
                              child: Text(currency,
                                  style: const TextStyle(color: Colors.white)),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("      "),
                const Text("         "),
                const SizedBox(
                  width: 100,
                ),
                Text(calculatedPrice,
                    style: const TextStyle(color: Colors.white)),
                const SizedBox(
                  width: 2,
                ),
                Text(convertedUnit,
                    style: const TextStyle(color: Colors.white)),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 100,
                  child: MaterialButton(
                    color: Color.fromARGB(255, 67, 97, 238),
                    child: const Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      _formKey.currentState!.save();
                      if (_formKey.currentState!.validate()) {
                        Dev.debug(_formKey.currentState!.value);
                        Map<String, dynamic> data =
                            _formKey.currentState!.value;
                        calculatePrice(data);
                      } else {
                        Dev.debug("validation failed");
                      }
                    },
                  ),
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }

  void calculatePrice(Map data) {
    double calculatedAmount = 0.0;
    if (data["currency"] != "INR") {
      calculatedAmount = double.parse(data["currencyQty"]) * currentINRPrice;
      convertedUnit = "INR";
    } else {
      calculatedAmount = double.parse(data["currencyQty"]) / currentINRPrice;
      convertedUnit = "USD";
    }
    setState(() {
      calculatedPrice = calculatedAmount.toStringAsFixed(2);
    });
  }

  resourceList() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      height: 100.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          SizedBox(
            width: 160.0,
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
                    child: Image.asset('assets/logo/fwg_farmerstoken.png'),
                  ),
                  title:
                      const Text('Gold', style: TextStyle(color: Colors.white)),
                  subtitle:
                      const Text('FWG', style: TextStyle(color: Colors.white)),
                ),
                Text(fwgPrice.toStringAsFixed(3),
                    style: const TextStyle(color: Colors.white)),
              ]),
            ),
          ),
          SizedBox(
            width: 160.0,
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
                    child: Image.asset('assets/logo/fwf_farmerstoken.png'),
                  ),
                  title:
                      const Text('Food', style: TextStyle(color: Colors.white)),
                  subtitle:
                      const Text('FWF', style: TextStyle(color: Colors.white)),
                ),
                Text(fwfPrice.toStringAsFixed(3),
                    style: const TextStyle(color: Colors.white)),
              ]),
            ),
          ),
          SizedBox(
            width: 160.0,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: const Color.fromARGB(255, 95, 13, 123),
              elevation: 10,
              child: Column(children: [
                ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/logo/fww_farmerstoken.png'),
                  ),
                  title:
                      const Text('Wood', style: TextStyle(color: Colors.white)),
                  subtitle:
                      const Text('FWW', style: TextStyle(color: Colors.white)),
                ),
                Text(fwwPrice.toStringAsFixed(3),
                    style: const TextStyle(color: Colors.white)),
              ]),
            ),
          ),
          // Container(
          //   width: 160.0,
          //   color: Colors.yellow,
          // ),
          // Container(
          //   width: 160.0,
          //   color: Colors.orange,
          // ),
        ],
      ),
    );
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

  Future<void> getAllFarmersWorldData() async {
    fwgPrice = await getFWPrice(fwg_api);
    fwwPrice = await getFWPrice(fww_api);
    fwfPrice = await getFWPrice(fwf_api);
  }

  copyToClipBoard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }
}
