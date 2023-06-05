import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:weather_uz/weather.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Dio dio = Dio();

  Future<Weather> getWeather(String city) async {
    var response = await dio.get("https://api.weatherapi.com/v1/forecast.json",
        queryParameters: {
          "key": "acb4a4de25aa41b784651422200510",
          "days": "3",
          "q": city
        });
    return Weather.fromJson(response.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ob Havo"),
      ),
      body: FutureBuilder(
          future: getWeather("Fergana"),
          builder: (BuildContext context, AsyncSnapshot<Weather> snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blue),
                      width: 100,
                      height: 100,
                      child: Column(
                        children: [
                          Image.network("https:" +
                              snapshot.data!.current!.condition!.icon
                                  .toString()),
                          Text(snapshot.data?.current?.tempC.toString() ??
                              "xato")
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data?.forecast?.forecastday?.length,
                        itemBuilder: (context, index) {
                          String? imageLink = snapshot.data?.forecast
                              ?.forecastday?[index].day?.condition?.icon;
                          String? temp = snapshot
                              .data?.forecast?.forecastday?[index].day?.avgtempC
                              .toString();
                          return Container(
                            margin: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.blue),
                            width: 100,
                            height: 100,
                            child: Column(
                              children: [
                                Image.network("https:${imageLink}"),
                                Text("${temp}")
                              ],
                            ),
                          );
                        }),
                  )
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
