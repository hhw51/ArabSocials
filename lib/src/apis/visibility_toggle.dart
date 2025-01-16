import 'dart:convert';
import 'package:http/http.dart' as http;

/// Model to parse the response from the server
class VisibilityPreferencesResponse {
  final String message;
  final Map<String, String> visibilitySettings;

  VisibilityPreferencesResponse({
    required this.message,
    required this.visibilitySettings,
  });

  factory VisibilityPreferencesResponse.fromJson(Map<String, dynamic> json) {
    return VisibilityPreferencesResponse(
      message: json['message'],
      visibilitySettings: Map<String, String>.from(json['visibility_settings']),
    );
  }
}

/// Service function to update visibility preferences
Future<VisibilityPreferencesResponse> updateVisibilityPreferences({
  required String authToken,
  // Visibility settings
  required bool email,
  required bool phone,
  required bool gender,
  required bool dob,
  required bool profession,
  required bool nationality,
  required bool maritalStatus,
}) async {
  final String url = 'http://35.222.126.155:8000/users/update-visibility-preferences/';
  print('--- Update Visibility Preferences ---');
  print('URL: $url');

  // Prepare headers
  Map<String, String> headers = {
    'Authorization': 'Bearer $authToken',
    // If CSRF token is required, include it here. Typically not needed for mobile apps.
    // 'Cookie': 'csrftoken=E3Jsth0BJT4fswUOar9dhKEnBchnYYSk',
  };
  print('Headers: $headers');

  // Prepare form data
  Map<String, String> formFields = {
    'email': email.toString(),
    'phone': phone.toString(),
    'gender': gender.toString(),
    'dob': dob.toString(),
    'profession': profession.toString(),
    'nationality': nationality.toString(),
    'marital_status': maritalStatus.toString(),
  };
  print('Form Fields: $formFields');

  try {
    // Create a MultipartRequest
    var request = http.MultipartRequest('PUT', Uri.parse(url));
    request.headers.addAll(headers);

    // Add form fields
    formFields.forEach((key, value) {
      request.fields[key] = value;
    });

    print('Sending PUT request...');

    // Send the request
    var streamedResponse = await request.send();

    // Convert streamed response to regular response
    var response = await http.Response.fromStream(streamedResponse);

    print('Received Response:');
    print('Status Code: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 200) {
      // Parse the JSON response
      var jsonResponse = json.decode(response.body);
      var visibilityResponse = VisibilityPreferencesResponse.fromJson(jsonResponse);
      print('Visibility preferences updated successfully.');
      return visibilityResponse;
    } else {
      // Handle errors
      print('Failed to update visibility preferences.');
      print('Error ${response.statusCode}: ${response.body}');
      throw Exception('Failed to update visibility preferences. Status Code: ${response.statusCode}');
    }
  } catch (e) {
    // Handle any exceptions
    print('An error occurred while updating visibility preferences: $e');
    rethrow;
  }
}
