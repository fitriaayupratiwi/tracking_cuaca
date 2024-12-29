import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Result extends StatefulWidget {
  final String place;
  const Result({super.key, required this.place});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  double averageTemp = 0;

  Future<Map<String, dynamic>> getDataFromAPI() async {
    final response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=${widget.place}&appid=c27737f0a01bbe157d14def5bac7ed59&units=metric"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Error fetching weather data!');
    }
  }

  double calculateAverageTemperature(Map<String, dynamic> weatherData) {
    double totalTemperature = 0;
    int count = 1;

    if (weatherData['main'] != null) {
      totalTemperature += weatherData['main']['temp'];
    }

    return count > 0 ? totalTemperature / count : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Hasil Tracking', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 70, right: 70),
        child: FutureBuilder(
          future: getDataFromAPI(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                  child: Text('Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red)));
            }

            if (snapshot.hasData) {
              final data = snapshot.data!;
              averageTemp = calculateAverageTemperature(data);

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'City: ${data['name']}',
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    'Cuaca: ${data['weather'][0]['description']}',
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    'Suhu: ${data["main"]["feels_like"]} C',
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    'Average Temperature: $averageTemp°C',
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    'Kecepatan angin: ${data["wind"]["speed"]} m/s',
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              );
            }

            return const Center(child: Text("Tempat tidak di ketahui"));
          },
        ),
      ),
    );
  }
}
