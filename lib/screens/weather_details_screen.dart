import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';

class WeatherDetailsScreen extends StatelessWidget {
  final Weather weather;

  const WeatherDetailsScreen({
    Key? key,
    required this.weather,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(weather.cityName),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 30),
              _buildDetailsCard(context),
              const SizedBox(height: 20),
              _buildAdditionalInfo(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            DateFormat('EEEE, d MMMM').format(weather.dateTime),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${weather.temperature.toStringAsFixed(1)}°',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              Image.network(
                'https://openweathermap.org/img/wn/${weather.iconCode}@2x.png',
                width: 80,
                height: 80,
              ),
            ],
          ),
          Text(
            weather.description.toUpperCase(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 5),
          Text(
            'Feels like ${weather.feelsLike.toStringAsFixed(1)}°',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDetailItem(
                  context,
                  Icons.thermostat,
                  'Min',
                  '${weather.minTemp.toStringAsFixed(1)}°',
                ),
                _buildDetailItem(
                  context,
                  Icons.thermostat,
                  'Max',
                  '${weather.maxTemp.toStringAsFixed(1)}°',
                ),
                _buildDetailItem(
                  context,
                  Icons.water_drop,
                  'Humidity',
                  '${weather.humidity}%',
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDetailItem(
                  context,
                  Icons.air,
                  'Wind',
                  '${weather.windSpeed} m/s',
                ),
                _buildDetailItem(
                  context,
                  Icons.compress,
                  'Pressure',
                  '${weather.pressure} hPa',
                ),
                _buildDetailItem(
                  context,
                  Icons.access_time,
                  'Updated',
                  DateFormat('HH:mm').format(weather.dateTime),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: 28,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfo(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weather Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildWeatherTip(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherTip(BuildContext context) {
    String tip;
    IconData iconData;

    // Provide weather tips based on conditions
    switch (weather.mainCondition.toLowerCase()) {
      case 'clear':
        tip = 'Clear skies! A great day to spend time outdoors.';
        iconData = Icons.wb_sunny;
        break;
      case 'clouds':
        tip = 'It\'s cloudy today. You might want to bring a light jacket.';
        iconData = Icons.cloud;
        break;
      case 'rain':
        tip = 'Don\'t forget your umbrella today!';
        iconData = Icons.umbrella;
        break;
      case 'thunderstorm':
        tip = 'Thunderstorms expected. Stay indoors if possible.';
        iconData = Icons.flash_on;
        break;
      case 'snow':
        tip = 'Bundle up! It\'s snowing outside.';
        iconData = Icons.ac_unit;
        break;
      default:
        tip = 'Check the forecast regularly for updates.';
        iconData = Icons.info_outline;
    }

    return Row(
      children: [
        Icon(
          iconData,
          size: 40,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            tip,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
