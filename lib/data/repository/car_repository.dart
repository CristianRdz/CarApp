import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/car_model.dart';

class CarRepository {
  final String apiUrl =
      'https://1prxlt9sde.execute-api.us-east-1.amazonaws.com/Prod';

  Future<void> createCar(CarModel car) async {
    final response = await http.post(
      Uri.parse('$apiUrl/cars'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(car.toJson()..remove('id')),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create car');
    }
  }

  Future<void> updateCar(CarModel car) async {
    final response = await http.put(
      Uri.parse('$apiUrl/cars'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(car.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update car');
    }
  }

  Future<void> deleteCar(String id) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/cars?id=$id'),
      headers: <String, String>{},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete car');
    }
  }

  Future<List<CarModel>> getAllCars() async {
    final response = await http.get(
      Uri.parse('$apiUrl/cars'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData =
          json.decode(response.body);
      final List<dynamic> carsData = jsonData['data'];
      return carsData.map((carData) => CarModel.fromJson(carData)).toList();
    } else {
      throw Exception('Failed to load cars');
    }
  }
}
