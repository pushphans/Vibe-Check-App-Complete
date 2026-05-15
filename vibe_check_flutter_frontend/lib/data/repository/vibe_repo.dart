import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../model/agent_response_model.dart';

class VibeRepo {
  Future<AgentResponseModel> analyze(String imageUrl) async {
    try {
      final uri = Uri.parse('http://10.0.2.2:8000/api/analyze');
      log('[VibeRepo] POST $uri');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'imageUrl': imageUrl}),
      );

      log('[VibeRepo] Status: ${response.statusCode}');
      log('[VibeRepo] Body: ${response.body}');

      if (response.statusCode == 200) {
        final model = AgentResponseModel.fromMap(
          json.decode(response.body) as Map<String, dynamic>,
        );
        log(
          '[VibeRepo] Parsed: vibeScore=${model.vibeScore}, fitScore=${model.fitScore}',
        );
        return model;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      log('[VibeRepo] Error: $e');
      rethrow;
    }
  }
}
