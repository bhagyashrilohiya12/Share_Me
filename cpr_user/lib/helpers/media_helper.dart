import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:typed_data';

class MediaHelper {
// Upload Large Media file

  Future<List> uploadMediaURL(String fileName) async {
    Map<String, String> qParams = {'fileName': fileName};
    var url = Uri.parse('https://app.ayrshare.com/api/media/uploadUrl');
    final finalUrl = url.replace(queryParameters: qParams);
    var response = await http.get(finalUrl, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer KFTB0MK-HQ54S8S-MNFWC5J-EEH7SBE',
    });
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to upload media URL.');
    }
  }

//Upload Image or Video

  Future<List> uploadMediaFile(String path) async {
    File infile = File(path); //convert Path to File
    Uint8List imagebytes = await infile.readAsBytes(); //convert to bytes
    String base64string =
        base64.encode(imagebytes); //convert bytes to base64 string
    String type = 'image/jpeg';
    String base = ';base64,';
    String file = 'data:' + type + base + base64string;
    var url = Uri.parse('https://app.ayrshare.com/api/media/upload');
    var response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer KFTB0MK-HQ54S8S-MNFWC5J-EEH7SBE',
        },
        body: jsonEncode({'file': file}));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to upload image or video.');
    }
  }

// Get All Images/Videos in gallery

  Future<List> getMediaFiles() async {
    var url = Uri.parse('https://app.ayrshare.com/api/media');
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
      throw Exception('Unable to fetch data from the Get media API.');
    }
  }
}
