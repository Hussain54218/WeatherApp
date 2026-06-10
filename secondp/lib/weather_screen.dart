import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:secondp/secrate.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weatherFuture;

  @override
  void initState() {
    super.initState();
    weatherFuture = getCurrentWeather();
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    const cityName = 'London';

    final response = await http.get(
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&units=metric&appid=$weatherOpneApiKey',
      ),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? 'Failed to load weather');
    }

    return data;
  }

  void refreshWeather() {
    setState(() {
      weatherFuture = getCurrentWeather();
    });
  }

  IconData getWeatherIcon(String sky) {
    switch (sky.toLowerCase()) {
      case 'clouds':
        return Icons.cloud;

      case 'rain':
      case 'drizzle':
        return Icons.grain;

      case 'thunderstorm':
        return Icons.flash_on;

      case 'clear':
        return Icons.wb_sunny;

      default:
        return Icons.cloud;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: refreshWeather,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: weatherFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  snapshot.error.toString(),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final data = snapshot.data!;

          final currentTemp = data['list'][0]['main']['temp'];
          final currentSky = data['list'][0]['weather'][0]['main'];

          final humidity =
              data['list'][0]['main']['humidity'].toString();

          final pressure =
              data['list'][0]['main']['pressure'].toString();

          final windSpeed =
              data['list'][0]['wind']['speed'].toString();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Current Weather Card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 24,
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${currentTemp.toString()}°C',
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          Icon(
                            getWeatherIcon(currentSky),
                            size: 64,
                          ),

                          const SizedBox(height: 16),

                          Text(
                            currentSky,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// Forecast Title
                const Text(
                  'Weather Forecast',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                /// Hourly Forecast
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      5,
                      (index) {
                        final item = data['list'][index + 1];

                        final temp =
                            item['main']['temp'].toString();

                        final sky =
                            item['weather'][0]['main'];

                        final time = item['dt_txt']
                            .toString()
                            .substring(11, 16);

                        return HourlyForecastCard(
                          time: time,
                          temperature: '$temp°C',
                          icon: getWeatherIcon(sky),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// Additional Information
                const Text(
                  'Additional Information',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfo(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: '$humidity%',
                    ),
                    AdditionalInfo(
                      icon: Icons.air,
                      label: 'Wind',
                      value: '$windSpeed m/s',
                    ),
                    AdditionalInfo(
                      icon: Icons.speed,
                      label: 'Pressure',
                      value: '$pressure hPa',
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class HourlyForecastCard extends StatelessWidget {
  final String time;
  final String temperature;
  final IconData icon;

  const HourlyForecastCard({
    super.key,
    required this.time,
    required this.temperature,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.only(right: 10),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Icon(icon, size: 32),
              const SizedBox(height: 10),
              Text(
                temperature,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AdditionalInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const AdditionalInfo({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 35),
        const SizedBox(height: 8),
        Text(label),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}