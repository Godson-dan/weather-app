import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:weather_app/services/weather_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherService weatherService = WeatherService();
  String city = "Benin City";

  Map<String, dynamic>? weatherData;
  List<Map<String, dynamic>> weatherDataList = [];

  void getWeather() async {
    try {
      final data = await weatherService.fetchWeather(city);
      setState(() {
        weatherData = data;
        weatherDataList = [
          {"label": "Humidity", "value": "${data["current"]["humidity"]}%"},
          {"label": "Wind", "value": "${data["current"]["wind_kph"]} km/h"},
          {
            "label": "Feels Like",
            "value": "${data["current"]["feelslike_c"]}°C"
          },
          {"label": "Dew Point", "value": "${data["current"]["dewpoint_c"]}°C"},
          {
            "label": "Pressure",
            "value": "${data["current"]["pressure_mb"]} hPa"
          },
          {"label": "UV Index", "value": "${data["current"]["uv"]}"},
          {"label": "Visibility", "value": "${data["current"]["vis_km"]} km"},
          {
            "label": "Wind Direction",
            "value": "${data["current"]["wind_dir"]}"
          },
          {
            "label": "Wind Degree",
            "value": "${data["current"]["wind_degree"]}°"
          },
          {"label": "Cloud", "value": "${data["current"]["cloud"]}%"},
          {
            "label": "Precipitation",
            "value": "${data["current"]["precip_mm"]} mm"
          },
        ];
      });
    } catch (e) {
      log('Error fetching weather data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.menu),
          onPressed: () {
            // For menu button action
            // I might change approch to use a drawer
            // or a bottom sheet for the menu
          },
        ),
        title: const Center(
          child: Text(
            'Weather App',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            color: Colors.white,
            iconSize: 30,
            icon: const Icon(Icons.search),
            onPressed: () {
              // Search will be done here
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: ListView(
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 25,
                    color: Colors.black.withOpacity(0.5),
                  ),
                  Text(
                    '${weatherData != null ? weatherData!["location"]["name"] : "Loading..."}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Container(
                  alignment: Alignment.topLeft,
                  child: weatherData != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${weatherData!["current"]["temp_c"]}°C',
                              style: const TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),

                            // Condition text and icon
                            Row(
                              children: [
                                // Condition text
                                Text(
                                  '${weatherData!["current"]["condition"]["text"]}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                // Condition icon
                                Image.network(
                                    "https:${weatherData!["current"]["condition"]["icon"]}")
                              ],
                            ),

                            Text(
                              'Last updated: ${weatherData!["current"]["last_updated"]}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                          ],
                        )
                      : const CircularProgressIndicator(),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    mainAxisExtent: 100),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: weatherDataList.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.green, width: 1),
                    ),
                    child: ListTile(
                      title: Text(
                        weatherDataList[index]["label"],
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        weatherDataList[index]["value"],
                        style: TextStyle(
                            fontSize: 18, color: Colors.black.withOpacity(0.5)),
                      ),
                      tileColor: Colors.blue.withOpacity(0.1),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
