import 'dart:convert';
import 'package:http/http.dart' as http;

class ZohoService {
  // Replace these with your actual credentials from the Zoho API Console
  final String orgId = 'YOUR_ORG_ID';
  final String clientId = 'YOUR_CLIENT_ID';
  final String clientSecret = 'YOUR_CLIENT_SECRET';
  final String refreshToken = 'YOUR_REFRESH_TOKEN';
  final String departmentId = 'YOUR_DEPARTMENT_ID';

  // Step 1: Get Access Token using Refresh Token
  Future<String?> getAccessToken() async {
    final url = Uri.parse('https://accounts.zoho.com/oauth/v2/token?'
        'refresh_token=$refreshToken&'
        'client_id=$clientId&'
        'client_secret=$clientSecret&'
        'grant_type=refresh_token');

    try {
      final response = await http.post(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['access_token'];
      } else {
        print('Failed to get Zoho token: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Zoho Auth Error: $e');
      return null;
    }
  }

  // Step 2: Create the Ticket
  Future<bool> createTicket({
    required String subject,
    required String description,
    required String email,
    String priority = 'Medium',
  }) async {
    final accessToken = await getAccessToken();
    if (accessToken == null) return false;

    final url = Uri.parse('https://desk.zoho.com/api/v1/tickets');
    
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Zoho-oauthtoken $accessToken',
          'orgId': orgId,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'subject': subject,
          'description': description,
          'contact': {
            'email': email,
            'lastName': 'App User',
          },
          'departmentId': departmentId,
          'priority': priority,
          'channel': 'Mobile App',
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Zoho Ticket Error: $e');
      return false;
    }
  }
}
