import 'package:http/http.dart' as http;
import 'dart:convert';

class PsychologistService {
  static const String baseUrl =
      "http://10.0.2.2:8000/api/psychologists"; // Android emulator

  static Future<List<dynamic>> getNearbyPsychologists(int userId) async {
    final url = "$baseUrl/nearby?user_id=$userId";

    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      throw Exception("Failed to load psychologists");
    }
  }
}
