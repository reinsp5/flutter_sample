import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ResultProvider with ChangeNotifier {
  static String GEOAPI = "msearch.gsi.go.jp";
  static String WEATHERAPI = "api.open-meteo.com";
  double _latitude = 0.0; // 緯度
  double _longitude = 0.0; // 経度
  String _placeName = ""; // 地名
  String _responseBody = "";

  var maps; // レスポンスの本文
  Map<String, dynamic> _geoParms = {};
  Map<String, dynamic> _weatherParms = {
    'timezone': 'Asia/Tokyo',
    'daily': 'weathercode',
    'hourly': 'temperature_2m',
  };
  List<String> _weathers = [];

  /// 緯度／経度のGetter
  double get latitude => _latitude;
  double get longitude => _longitude;
  String get placeName => _placeName;
  String get responseBody => _responseBody;
  List<String> get weathers => _weathers;

  /// 緯度／経度のSetter
  set latitude(latitude) {
    _latitude = latitude;
    notifyListeners();
  }

  set longitude(longitude) {
    _longitude = longitude;
    notifyListeners();
  }

  set placeName(placeName) {
    _placeName = placeName;
    notifyListeners();
  }

  /// 国土地理院APIが返したレスポンスの先頭要素から緯度／経度を設定する
  void getGeoPosition() {
    _placeName2GeoPosition().then((value) {
      if (value.statusCode == 200) {
        _responseBody = value.body;
        maps = jsonDecode(_responseBody);
        _latitude = maps[0]["geometry"]["coordinates"][1];
        _longitude = maps[0]["geometry"]["coordinates"][0];
        getWeatherInfo();
        notifyListeners();
      }
    });
  }

  /// 地名から緯度／経度を求める（国土地理院API使用）
  Future<http.Response> _placeName2GeoPosition() {
    _geoParms = {
      'q': _placeName,
    };
    Uri _uri = Uri.https(GEOAPI, '/address-search/AddressSearch', _geoParms);
    return http.get(Uri.parse(_uri.toString()));
  }

  void getWeatherInfo() {
    print("getWeatherInfo");
    _requestWeather().then((value) {
      print(value.statusCode);
      if (value.statusCode == 200) {
        _weathers = [];
        _responseBody = value.body;
        maps = jsonDecode(_responseBody);
        print(maps["daily"]["weathercode"]);
        for (int map in maps["daily"]["weathercode"]) {
          switch (map) {
            case 0:
              _weathers.add("快晴");
              break;
            case 1:
              _weathers.add("晴れ");
              break;
            case 2:
              _weathers.add("晴れ時々曇り");
              break;
            case 3:
              _weathers.add("曇り");
              break;
            case 45:
              _weathers.add("霧");
              break;
            case 48:
              _weathers.add("濃霧");
              break;
            case 51:
            case 53:
            case 55:
            case 56:
            case 57:
              _weathers.add("霧雨");
              break;
            case 61:
            case 63:
            case 65:
            case 66:
            case 67:
              _weathers.add("雨");
              break;
            case 71:
            case 73:
            case 75:
            case 77:
              _weathers.add("雪");
              break;
            case 80:
            case 81:
            case 82:
              _weathers.add("にわか雨");
              break;
            case 85:
            case 86:
              _weathers.add("みぞれ雪");
              break;
            default:
              _weathers.add("不明");
          }
        }
        notifyListeners();
      }
    }).catchError((e) {
      print(e.toString());
    });
  }

  /// 緯度／経度をもとにその時点の天気予報を取得する
  Future<http.Response> _requestWeather() async {
    _weatherParms.addAll({
      'latitude': _latitude.toString(),
      'longitude': _longitude.toString(),
    });
    Uri _uri = Uri.https(WEATHERAPI, '/v1/forecast', _weatherParms);
    print(_uri.toString());
    return await http.get(Uri.parse(_uri.toString()));
  }
}
