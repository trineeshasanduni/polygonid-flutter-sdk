import 'dart:convert';
import 'package:http/http.dart' as http;



Future<String> addUser(

      String Commitment, String Did, String NullifierHash, String Owner) async {

       const BASE_URL = 'https://test.becx.io/api/v1';

    print('add user up');
    try {
      // Construct the data to be sent
      Map<String, dynamic> data = {
        "Commitment": Commitment,
        "Did": Did,
        "NullifierHash": NullifierHash,
        "Owner": Owner,
      };
      print('add user data: $data');

      // Define the URI for the sign-up API endpoint
      final uri = Uri.parse('$BASE_URL/add-user');

      // Make the POST request with the proper headers and body
      final response = await http.post(
        uri,
        // headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      print('add user status code: ${response.statusCode}');

      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      print('add user Status Code: ${response.statusCode}');
      print('add user Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonEncode(jsonResponse);
        // return jsonResponse;
      } else {
        print('Failed to add user');
        // return response.body;
      }
      return jsonEncode(jsonResponse);
    } catch (error) {
      print('Error during add user: $error');
      throw Exception('Failed to add user');
    }
  }