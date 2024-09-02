import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenRouteService {
  // final String apiKey = '5b3ce3597851110001cf62484ba28ebc14df488b92df85c465d06ea5';
  // final String baseUrl = 'https://api.openrouteservice.org/v2/directions/driving-car';

  Future<double> getDistance(double startLat, double startLng, double endLat, double endLng) async {
   print('$startLat----------------');
   print(startLng);
    final response = await http.get(
      Uri.parse('https://api.openrouteservice.org/v2/directions/cycling-regular?api_key=5b3ce3597851110001cf62484ba28ebc14df488b92df85c465d06ea5&start=$startLng,$startLat&end=$endLng,$endLat'),
    );
try{
     if (response.statusCode == 200) {
      print('helo');
      final data = json.decode(response.body);
      final distance = data['features'][0]['properties']['segments'][0]['distance'];
      print(data['features'][0]['properties']['segments'][0]);
      return distance / 1000; // Convert from meters to kilomeawters
    } else {
      return -1; // Indicate failure with a special value
    }
  } catch(e) {
    print('Error: $e');
    return -1; // Indicate failure with a special value
  }
  }
}