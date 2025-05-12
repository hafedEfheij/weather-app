class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final String description;
  final int humidity;
  final double windSpeed;
  final String iconCode;
  final DateTime dateTime;
  final double feelsLike;
  final int pressure;
  final double minTemp;
  final double maxTemp;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.iconCode,
    required this.dateTime,
    required this.feelsLike,
    required this.pressure,
    required this.minTemp,
    required this.maxTemp,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
      description: json['weather'][0]['description'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      iconCode: json['weather'][0]['icon'],
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      feelsLike: json['main']['feels_like'].toDouble(),
      pressure: json['main']['pressure'],
      minTemp: json['main']['temp_min'].toDouble(),
      maxTemp: json['main']['temp_max'].toDouble(),
    );
  }
}

class ForecastDay {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final String iconCode;
  final String condition;

  ForecastDay({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.iconCode,
    required this.condition,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    return ForecastDay(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      maxTemp: json['main']['temp_max'].toDouble(),
      minTemp: json['main']['temp_min'].toDouble(),
      iconCode: json['weather'][0]['icon'],
      condition: json['weather'][0]['main'],
    );
  }
}
