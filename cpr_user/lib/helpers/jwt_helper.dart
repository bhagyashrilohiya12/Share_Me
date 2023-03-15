import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

class JWTHelper {
// Generate jwt

  Future<List> generateJWT() async {
    String privateKey = await rootBundle.loadString('assets/private_key.key');
    //  String data = await getFileData(fileName);
    String profileKey = '44FJYMM-72X4FJ1-J6MYBE0-FSGTPE4';
    String domain = 'clickpicreview';
    var url = Uri.parse('https://app.ayrshare.com/api/profiles/generateJWT');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer KFTB0MK-HQ54S8S-MNFWC5J-EEH7SBE',
      },
      body: jsonEncode(<String, String>{
        'privateKey': privateKey,
        'profileKey': profileKey,
        'domain': domain
      }),
    );
    if (response.statusCode == 200) {
      var output = json.decode(response.body);
      print(output);
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create user profile.');
    }
  }

////Get information on the user or user profile including linked social networks and social usernames.
  Future<List> getUserDetails() async {
    var url = Uri.parse('https://app.ayrshare.com/api/user');
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer KFTB0MK-HQ54S8S-MNFWC5J-EEH7SBE',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Unable to fetch data from the Get User Profile API');
    }
  }

////Get the details of a particular platform. Current support for Pinterest Boards.
  Future<List> getUserPlatform() async {
    var url = Uri.parse('https://app.ayrshare.com/api/user/details/pinterest');
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer KFTB0MK-HQ54S8S-MNFWC5J-EEH7SBE',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Unable to fetch data from the Get User Profile API');
    }
  }
}
