import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/weather_model.dart';

class WeatherService {
  static const String _apiKey = 'YOUR_OPENWEATHERMAP_API_KEY'; // Replace with your API key
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  // Get current weather by city name
  Future<Weather> getWeatherByCity(String cityName) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/weather?q=$cityName&units=metric&appid=$_apiKey'),
    );

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  // Get current weather by location coordinates
  Future<Weather> getWeatherByLocation(double latitude, double longitude) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/weather?lat=$latitude&lon=$longitude&units=metric&appid=$_apiKey'),
    );

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  // Get 5-day forecast by city name
  Future<List<ForecastDay>> getForecastByCity(String cityName) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/forecast?q=$cityName&units=metric&appid=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> forecastList = data['list'];
      
      // Get one forecast per day (noon time)
      final Map<String, ForecastDay> dailyForecasts = {};
      
      for (var item in forecastList) {
        final date = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
        final dateString = '${date.year}-${date.month}-${date.day}';
        
        if (!dailyForecasts.containsKey(dateString)) {
          dailyForecasts[dateString] = ForecastDay.fromJson(item);
        }
      }
      
      return dailyForecasts.values.toList();
    } else {
      throw Exception('Failed to load forecast data');
    }
  }

  // Get current location
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    // Get current position
    return await Geolocator.getCurrentPosition();
  }

  // Get address from coordinates
  Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return place.locality ?? 'Unknown';
      }
      return 'Unknown';
    } catch (e) {
      return 'Unknown';
    }
  }
}
