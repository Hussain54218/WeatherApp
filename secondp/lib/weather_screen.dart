import 'package:flutter/material.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,

              child: Card(
                elevation: 5,

                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    children: const [
                      Text(
                        "63°F",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Icon(Icons.cloud, size: 64),
                      SizedBox(height: 16),
                      Text("Rain", style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),
            Text(
              "Weather forecast",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  HourlyForecastCart(),
                  HourlyForecastCart(),
                  HourlyForecastCart(),
                  HourlyForecastCart(),
                  HourlyForecastCart(),
                  HourlyForecastCart(),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              "Adetainal information",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AdditionalInfo(icon: Icons.water_drop,lable:"Humitity",value:"63°",),
                AdditionalInfo(icon: Icons.air,lable: "hussain",value: "90°",),
                AdditionalInfo(icon: Icons.thermostat,lable: "Ali",value: "100°",),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HourlyForecastCart extends StatelessWidget {
  HourlyForecastCart({super.key});
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 100,
      child: Card(
        elevation: 6,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Text(
                "09:000",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Icon(Icons.cloud, size: 32),
              SizedBox(height: 8),
              Text("320.12", style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}

class AdditionalInfo extends StatelessWidget {
  final IconData icon;
  final String lable;
  final String value;
  AdditionalInfo({super.key, required this.icon,required this.lable,required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 35),
         Text(lable),
        const SizedBox(height: 8),
         Text(value),
      ],
    );
  }
}
