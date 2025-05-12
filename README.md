# Weather App

A Flutter application that displays weather information for different locations.

## Features

- View current weather for your location
- Search for weather by city name
- View 5-day weather forecast
- Detailed weather information (temperature, humidity, wind speed, etc.)
- Beautiful UI with weather-based gradients

## Getting Started

### Prerequisites

- Flutter SDK (latest version recommended)
- Android Studio / VS Code
- Android / iOS device or emulator

### Installation

1. Clone this repository
2. Navigate to the project directory
3. Run `flutter pub get` to install dependencies
4. Get an API key from [OpenWeatherMap](https://openweathermap.org/api)
5. Replace `YOUR_OPENWEATHERMAP_API_KEY` in `lib/services/weather_service.dart` with your actual API key
6. Run the app with `flutter run`

### Dependencies

- http: For making API requests
- geolocator: For getting the user's current location
- geocoding: For converting coordinates to addresses
- intl: For date formatting
- provider: For state management
- flutter_spinkit: For loading animations

## Usage

- When you first open the app, it will request your location to show the weather for your current location
- Use the search bar to find weather for any city
- Tap on the weather card to view detailed information
- Pull down to refresh the weather data
- Swipe horizontally to view the 5-day forecast

## Screenshots

(Add screenshots here)

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgements

- [OpenWeatherMap](https://openweathermap.org/) for providing the weather data API
- [Flutter](https://flutter.dev/) for the amazing framework
