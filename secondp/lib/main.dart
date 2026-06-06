import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:secondp/weather_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData.dark(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home:WeatherScreen(
      
    ));
  }
}
