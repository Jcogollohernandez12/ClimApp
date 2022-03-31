import 'dart:async';
import 'dart:io';
import 'package:weather/src/helpers/debouncer.dart';
import 'package:weather/src/models/location.dart';
import 'package:weather/src/models/result.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherService with ChangeNotifier {
  String urlQuery = "https://www.metaweather.com/api/location/search/?query=";
  String urlLocation = "https://www.metaweather.com/api/location/";
  String urlImage = "https://www.metaweather.com/static/img/weather/png/";
  late Location location;

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500),
  );

  final StreamController<List<Result>> _suggestioflutternStreamContoller =
      StreamController.broadcast();

  Stream<List<Result>> get suggestionStream =>
      _suggestioflutternStreamContoller.stream;

  get suggestionSink => _suggestioflutternStreamContoller.close();

  WeatherService();

  Future<dynamic> searchLocations(String query) async {
    final url = urlQuery + query;

    try {
      final res = await http.get(Uri.parse(url));
      final search = resultFromJson(res.body);
      return search;
    } on SocketException catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> searchLocation(int id) async {
    final url = urlLocation + id.toString();
    try {
      final res = await http.get(Uri.parse(url));
      final data = locationFromJson(res.body);
      location = data;
      return data;
    } on SocketException catch (e) {
      // ignore: avoid_print
      print(e.message);
      return [];
    }
  }

  void getSuggestionsByQuery(String searchTerm) {
    debouncer.value = '';

    debouncer.onValue = (value) async {
      final results = await searchLocations(value);
      _suggestioflutternStreamContoller.add(results);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      debouncer.value = searchTerm;
    });

    Future.delayed(const Duration(milliseconds: 51))
        .then((_) => timer.cancel());
  }

  //void cerrar() {
  //  _suggestionStreamContoller.onCancel;
  //}
}
