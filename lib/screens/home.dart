import 'dart:convert';
import 'package:currency_calculator/pojo/CoinToINR.dart';
import 'package:currency_calculator/pojo/CoinToUSD.dart';
import 'package:currency_calculator/pojo/alcormarket_response.dart';
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
  var dio;
  String INR_UNIT = "INR";

  String USD_UNIT = "USD";
  final _formKey = GlobalKey<FormBuilderState>();

  var coinOptions = ["BTC", "ETH", "WAXP"];

  var currencyOptions = ["INR", "USD"];

  String convertedPriceINR = "";

  String convertedPriceUSD = "";

  double estimatedAmount = 0.0;

  double currentINRPrice = 0.0;

  String calculatedPrice = "0.0";

  String convertedUnit = "";

  bool isLoadingInrPrice = false;
  bool isLoadingCryptoPrice = false;

  late Map<String, dynamic> inputAmount;

  bool isLoadingCryptoPriceUsd = false;

  bool isLoadingCryptoPriceINR = false;

  @override
  void initState() {
    dio = Dio();
    _refreshData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CryptoConverter'),
        actions: [
          !isLoadingInrPrice
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
        ],
      ),
      body: Container(
        color: Colors.black12,
        child: bodyUI(),
      ),
    );
  }

  _refreshData() async {
    getUsdToINR();
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

  Future<void> getUsdToINR() async {
    isLoadingInrPrice = true;
    var params = {'amount': 1, 'symbol': "USD", 'convert': "INR"};
    var header = {
      'Content-Type': 'application/json',
      'X-CMC_PRO_API_KEY': '60107775-bc9f-48f8-8c5f-59556ccd0583',
      'Accept-Encoding': 'deflate, gzip'
    };
    var url = 'https://pro-api.coinmarketcap.com/v1/tools/price-conversion';
    Dev.debug('getEstimatedAmount : $url');
    Dev.debug('params : $params');
    var response = await dio.get(url,
        options: Options(headers: header), queryParameters: params);
    var currencyResponse = CoinToInr.fromJson(response.data);

    Dev.debug(currencyResponse.data.quote.inr.price);
    setState(() {
      currentINRPrice = currencyResponse.data.quote.inr.price;
      isLoadingInrPrice = false;
    });
  }

  getEstimatedAmountINR(double unpaidEth, String fromCurrency) {
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
    Dev.debug('getEstimatedAmountINR : $url');
    Dev.debug('getEstimatedAmountINR params : $params');
    dio
        .get(url, options: Options(headers: header), queryParameters: params)
        .then((response) {
      var currencyResponse = CoinToInr.fromJson(response.data);

      setState(() {
        isLoadingCryptoPriceINR = false;
        convertedPriceINR =
            currencyResponse.data.quote.inr.price.toStringAsFixed(4);
      });
      Dev.debug(
          'getEstimatedAmountINR Price Inr : ${currencyResponse.data.quote.inr.price}');
    });
    // .catchError((error) => handleHttpError(error));
  }

  getEstimatedAmountUSD(double unpaidEth, String fromCurrency) {
    isLoadingCryptoPriceUsd = true;
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
    Dev.debug('getEstimatedAmountUSD : $url');
    Dev.debug('getEstimatedAmountUSD params : $params');
    dio
        .get(url, options: Options(headers: header), queryParameters: params)
        .then((response) {
      var currencyResponse = CoinToUsd.fromJson(response.data);

      setState(() {
        isLoadingCryptoPriceUsd = false;
        convertedPriceUSD =
            currencyResponse.data.quote.usd.price.toStringAsFixed(2);
      });
      Dev.debug(
          "getEstimatedAmountUSD Price USD :${currencyResponse.data.quote.usd.price}");
    });
  }

  handleHttpError(DioError error) {
    Dev.debug('handleHttpError: message ${error.message}.');
    Dev.debug('handleHttpError: error ${error.error}.');
    Dev.debug('handleHttpError:  $error.');
  }

  cryptoConverter() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: const Color.fromARGB(255, 63, 55, 201),
        elevation: 10,
        child: Column(children: [
          conversionRate(),
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
              isLoadingCryptoPriceUsd
                  ? getCircularProgressIndicator(20)
                  : Row(
                      children: [
                        Text(convertedPriceUSD,
                            style: const TextStyle(color: Colors.white)),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(USD_UNIT,
                            style: const TextStyle(color: Colors.white)),
                        IconButton(
                          enableFeedback: true,
                          onPressed: () {
                            copyToClipBoard(convertedPriceUSD);
                          },
                          icon: const Icon(
                            Icons.copy,
                            size: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
              const SizedBox(
                width: 50,
              ),
              isLoadingCryptoPriceINR
                  ? getCircularProgressIndicator(20)
                  : Row(
                      children: [
                        Text(convertedPriceINR,
                            style: const TextStyle(color: Colors.white)),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(INR_UNIT,
                            style: const TextStyle(color: Colors.white)),
                        IconButton(
                          enableFeedback: true,
                          onPressed: () {
                            copyToClipBoard(INR_UNIT);
                          },
                          icon: const Icon(
                            Icons.copy,
                            size: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
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
    );
  }

  currencyConverter() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: const Color.fromARGB(255, 58, 12, 163),
        elevation: 10,
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 100,
                child: FormBuilderTextField(
                  name: 'currencyQty',

                  decoration: const InputDecoration(
                    labelText: 'Amount',
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
                  onChanged: _calculateConversion,
                  dropdownColor: const Color.fromARGB(255, 181, 23, 158),
                  hint: const Text('Select',
                      style: TextStyle(color: Colors.white)),
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
              Row(
                children: [
                  Text(calculatedPrice,
                      style: const TextStyle(color: Colors.white)),
                  const SizedBox(
                    width: 2,
                  ),
                  Text(convertedUnit,
                      style: const TextStyle(color: Colors.white)),
                  IconButton(
                    enableFeedback: true,
                    onPressed: () {
                      copyToClipBoard(calculatedPrice);
                    },
                    icon: const Icon(
                      Icons.copy,
                      size: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
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
                  color: const Color.fromARGB(255, 67, 97, 238),
                  child: const Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    // _formKey.currentState!.save();
                    // if (_formKey.currentState!.validate()) {
                    //   Dev.debug(_formKey.currentState!.value);
                    //   Map<String, dynamic> data =
                    //       _formKey.currentState!.value;
                    //   calculatePrice(data);
                    // } else {
                    //   Dev.debug("validation failed");
                    // }
                  },
                ),
              ),
            ],
          )
        ]),
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

  copyToClipBoard(String text) {
    Dev.debug("copied $text");
    Clipboard.setData(ClipboardData(text: text));
  }

  // void setGlobalLoadingDataState() {
  //   if (isLoadingFwfPrice &&
  //       isLoadingFwgPrice &&
  //       isLoadingFwwPrice &&
  //       isLoadingInrPrice) {
  //     setState(() {
  //       isLoadingGlobalData = true;
  //     });
  //   } else {
  //     setState(() {
  //       isLoadingGlobalData = false;
  //     });
  //   }
  // }

  getCircularProgressIndicator(double size) {
    return Center(
      child: SleekCircularSlider(
        appearance: CircularSliderAppearance(
          size: size,
          spinnerMode: true,
        ),
      ),
    );
  }

  conversionRate() {
    return ListTile(
      // leading: Icon(Icons.album, size: 70),
      title: Row(
        children: [
          const Text('1 USD = ', style: TextStyle(color: Colors.white)),
          isLoadingInrPrice
              ? getCircularProgressIndicator(20.0)
              : Text('${currentINRPrice.toStringAsFixed(2)} INR',
                  style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  void _calculateConversion(String? value) {
    Dev.debug("_calculateConversion  $value");
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      Dev.debug(_formKey.currentState!.value);
      Map<String, dynamic> data = _formKey.currentState!.value;
      calculatePrice(data);
    } else {
      Dev.debug("validation failed");
    }
  }
}
