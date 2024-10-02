import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenRouteService {
  final String apiKey =
      '5b3ce3597851110001cf62484ba28ebc14df488b92df85c465d06ea5';
  final String baseUrl =
      'https://api.openrouteservice.org/v2/matrix/cycling-regular';

  Future<List<Map<String, dynamic>>> getVendorsWithinThreshold(double sourceLat,
      double sourceLng, List vendors, double threshold) async {
    // Extract the locations from the vendor details
    List<List> locations = [
      [sourceLng, sourceLat],
      ...vendors.map((vendor) => [vendor['vlong'], vendor['vlat']]).toList(),
    ];
    print(vendors);
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': apiKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'locations': locations,
        'metrics': ['distance'],
      }),
    );

    try {
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final distances =
            data['distances'][0]; // Distances from the source to all vendors

        // Filter vendors whose distance is below the threshold
        print('distances');
        print(distances);
        print('Request body: ${jsonEncode({
              'locations': locations,
              'metrics': ['distance'],
            })}');
        print('Response body: ${response.body}');

        List<Map<String, dynamic>> filteredVendors = [];
        for (int i = 0; i < vendors.length; i++) {
          double distanceInKm = distances[i + 1] ??
              -1 / 1000; // Convert from meters to kilometers
          if (distanceInKm < threshold && distanceInKm > 0) {
            vendors[i]['distance'] =
                distanceInKm; // Optionally add the distance to the vendor data
            filteredVendors.add(vendors[i]);
          }
        }

        return filteredVendors;
      } else {
        print('Request failed with status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
}
