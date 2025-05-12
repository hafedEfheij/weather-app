import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../services/weather_provider.dart';
import '../widgets/weather_card.dart';
import '../widgets/forecast_card.dart';
import 'weather_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    // Get weather for current location when app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WeatherProvider>(context, listen: false)
          .getWeatherByCurrentLocation();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          return SafeArea(
            child: Column(
              children: [
                _buildSearchBar(context, weatherProvider),
                Expanded(
                  child: weatherProvider.isLoading
                      ? _buildLoadingIndicator()
                      : weatherProvider.error.isNotEmpty
                          ? _buildErrorMessage(weatherProvider.error)
                          : weatherProvider.currentWeather == null
                              ? _buildInitialMessage()
                              : _buildWeatherContent(context, weatherProvider),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, WeatherProvider weatherProvider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search city',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  weatherProvider.getWeatherByCity(value);
                  _searchController.clear();
                }
              },
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              weatherProvider.getWeatherByCurrentLocation();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: SpinKitPulse(
        color: Colors.blue,
        size: 50.0,
      ),
    );
  }

  Widget _buildErrorMessage(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              'Error',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialMessage() {
    return const Center(
      child: Text('Search for a city or use your current location'),
    );
  }

  Widget _buildWeatherContent(BuildContext context, WeatherProvider weatherProvider) {
    final weather = weatherProvider.currentWeather!;
    final forecast = weatherProvider.forecast;
    
    return RefreshIndicator(
      onRefresh: () async {
        if (weather.cityName.isNotEmpty) {
          await weatherProvider.getWeatherByCity(weather.cityName);
        } else {
          await weatherProvider.getWeatherByCurrentLocation();
        }
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WeatherCard(
                weather: weather,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WeatherDetailsScreen(
                        weather: weather,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Text(
                '5-Day Forecast',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: forecast.length,
                  itemBuilder: (context, index) {
                    return ForecastCard(forecast: forecast[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
