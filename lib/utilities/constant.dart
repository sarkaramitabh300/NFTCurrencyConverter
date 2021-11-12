import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

const Map<String, dynamic> assetTemplateMapping = {
  '203887': 'assets/images/fishing_rod.png',
  '260763': 'assets/images/stoneaex.png',
};
const Map<String, dynamic> assetCurrencyToken = {
  'TLM': 'assets/logo/tlm.png',
  'FWF': 'assets/logo/FWF2.png',
  'FWG': 'assets/logo/FWG2.png',
  'FWW': 'assets/logo/FWW2.png',
  'WAX': 'assets/logo/wax.svg',
};
const String currencyPrefKey="counter";
const List<String> featCurrencyId = [
  "usd",
  "aed",
  "ars",
  "aud",
  "bdt",
  "bhd",
  "bmd",
  "brl",
  "cad",
  "chf",
  "clp",
  "cny",
  "czk",
  "dkk",
  "eur",
  "gbp",
  "hkd",
  "huf",
  "idr",
  "ils",
  "inr",
  "jpy",
  "krw",
  "kwd",
  "lkr",
  "mmk",
  "mxn",
  "myr",
  "ngn",
  "nok",
  "nzd",
  "php",
  "pkr",
  "pln",
  "rub",
  "sar",
  "sek",
  "sgd",
  "thb",
  "try",
  "twd",
  "uah",
  "vef",
  "vnd",
  "zar",
  "xdr",
  "xag",
  "xau",
  "bits",
  "sats"
];

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
