import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:weathet_app/models/weather_forecast_hourly.dart';
import 'package:weathet_app/utils/constants.dart';
import 'package:weathet_app/utils/location.dart';

class WeatherApi {
  final _client = HttpClient();

  static const _host = Constants.weatherbasescheme + Constants.weatherbaseurldomain;

  Uri _makeUri(String path, [Map<String, dynamic>? parameters]) {
    final uri = Uri.parse('$_host$path');
    if (parameters != null) {
      return uri.replace(queryParameters: parameters);
    } else {
      return uri;
    }
  }

  Future<WeatherForecastModel> fetchWeatherForecast(
      {String? cityName}) async {
    
    Map<String, String> parameters;

    if (cityName!=null && cityName.isNotEmpty) {
      parameters = {
        'key': Constants.weatherappid,
        'q': cityName,
        'days': '1',
      };
    } else {
      UserLocation location = UserLocation();
    await location.determinePosition();
      String fullLocation = '${location.latitude},${location.longitude}';
      parameters = {
        'key': Constants.weatherappid,
        'q': fullLocation,
        'days': '1',
      };
    }

    final url = _makeUri(Constants.weatherforeccastpath, parameters);

    log('request: ${url.toString()}');
    final request = await _client.getUrl(url);
    final response = await request.close();
    final json = await response
        .transform(utf8.decoder)
        .toList()
        .then((value) => value.join())
        .then<dynamic>((val) => jsonDecode(val)) as Map<String, dynamic>;
    return WeatherForecastModel.fromJson(json);
  }
}
