import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';
import 'weather_service.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  
  Weather? _currentWeather;
  List<ForecastDay> _forecast = [];
  bool _isLoading = false;
  String _error = '';

  Weather? get currentWeather => _currentWeather;
  List<ForecastDay> get forecast => _forecast;
  bool get isLoading => _isLoading;
  String get error => _error;

  // Get weather by city name
  Future<void> getWeatherByCity(String cityName) async {
    _setLoading(true);
    _clearError();
    
    try {
      final weather = await _weatherService.getWeatherByCity(cityName);
      _currentWeather = weather;
      
      // Get forecast data
      _forecast = await _weatherService.getForecastByCity(cityName);
      
      _setLoading(false);
    } catch (e) {
      _setError('Failed to get weather for $cityName: ${e.toString()}');
      _setLoading(false);
    }
  }

  // Get weather by current location
  Future<void> getWeatherByCurrentLocation() async {
    _setLoading(true);
    _clearError();
    
    try {
      // Get current location
      final position = await _weatherService.getCurrentLocation();
      
      // Get weather data for current location
      final weather = await _weatherService.getWeatherByLocation(
        position.latitude, 
        position.longitude
      );
      _currentWeather = weather;
      
      // Get forecast data
      _forecast = await _weatherService.getForecastByCity(weather.cityName);
      
      _setLoading(false);
    } catch (e) {
      _setError('Failed to get weather for current location: ${e.toString()}');
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _error = message;
    notifyListeners();
  }

  void _clearError() {
    _error = '';
    notifyListeners();
  }
}
