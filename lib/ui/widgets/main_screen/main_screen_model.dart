import 'package:flutter/cupertino.dart';
import 'package:weathet_app/api/weather_api.dart';
import 'package:weathet_app/models/weather_forecast_hourly.dart';

class MainScreenModel extends ChangeNotifier {
  WeatherForecastModel? _forecastObject;
  WeatherForecastModel? get forecastObject => _forecastObject;

  bool _loading = true;
  bool get loading => _loading;
  String cityName = '';

  MainScreenModel() {
    setup();
  }

  Future<void> setup() async {
    _forecastObject ??=
        await WeatherApi().fetchWeatherForecast(cityName: 'Patika');
    updateState();
  }

  void onSubmitLocate() async {
    updateState();
    _forecastObject = await WeatherApi().fetchWeatherForecast();
    cityName = _forecastObject!.location!.name!;
    updateState();
  }

  void onSubmitSearch() async {
    if (cityName.isEmpty) return;
    updateState();
    _forecastObject =
        await WeatherApi().fetchWeatherForecast(cityName: cityName);
    cityName = '';
    updateState();
  }

  void updateState() {
    _loading = !_loading;

    notifyListeners();
  }
}
