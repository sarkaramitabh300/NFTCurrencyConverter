import 'package:currency_calculator/pojo/CoinToINR.dart';
import 'package:currency_calculator/pojo/CoinToUSD.dart';
import 'package:currency_calculator/utilities/dev.log.dart';
import 'package:dio/dio.dart';

class Converter {
  getEstimatedAmountINR(dio, double amount, String fromCurrency) async {
    var params = {'amount': amount, 'symbol': fromCurrency, 'convert': "INR"};
    var header = {
      'Content-Type': 'application/json',
      'X-CMC_PRO_API_KEY': '60107775-bc9f-48f8-8c5f-59556ccd0583',
      'Accept-Encoding': 'deflate, gzip'
    };
    var url = 'https://pro-api.coinmarketcap.com/v1/tools/price-conversion';
    Dev.debug('getEstimatedAmountINR URL: $url');
    Dev.debug('getEstimatedAmountINR params : $params');
    try {
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
      print(e);
      return 0.0;
    }
  }

  getEstimatedAmountUSD(dio, double amount, String fromCurrency) async {
    var params = {'amount': amount, 'symbol': fromCurrency, 'convert': "USD"};
    var header = {
      'Content-Type': 'application/json',
      'X-CMC_PRO_API_KEY': '60107775-bc9f-48f8-8c5f-59556ccd0583',
      'Accept-Encoding': 'deflate, gzip'
    };
    var url = 'https://pro-api.coinmarketcap.com/v1/tools/price-conversion';
    Dev.debug('getEstimatedAmountINR URL: $url');
    Dev.debug('getEstimatedAmountINR params : $params');
    try {
      var response = await dio.get(url,
          options: Options(headers: header), queryParameters: params);
      var myData = CoinToUsd.fromJson(response.data);

      // print('hh ${myData.data.quote.usd.price}');

      return myData.data.quote.usd.price;
    } on DioError catch (e) {
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
      print(e);
      return 0.0;
    }
  }

  double gameTokenToWax(double tokenMarketPriceInWax, double tokenAmount) {
    return tokenMarketPriceInWax * tokenAmount;
  }

  waxToINR(double tokenMarketPriceInWax, double tokenAmount) {
    return tokenMarketPriceInWax * tokenAmount;
  }

  calculateTokenAmountINR(fwgPrice, waxInInr, String token) {
    Dev.debug("$token :: $fwgPrice WaxINR = $waxInInr,  RS =${fwgPrice * waxInInr}");
    return fwgPrice * waxInInr;
  }
}
