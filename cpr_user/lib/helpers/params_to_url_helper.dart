import 'package:flutter/cupertino.dart';

String paramsToUrl({required Map params, required String url}) {
  String newUrl = url + "?";
  print(params);
  Map simpleValue = Map();
  Map listValue = Map();

  params.forEach((key, value) {
    if (value is List<dynamic>) {
      listValue.addAll({key: value});
    } else if (value != null) {
      simpleValue.addAll({key: value});
    }
  });

  simpleValue.forEach((key, value) {
    newUrl += (key.toString() + "=" + value.toString() + "&");
  });
  listValue.forEach((key, value) {
    String listParams = "";
    value.forEach((element) {
      listParams += "$key=$element&";
    });
    newUrl += (listParams);
  });

  return newUrl;
}

bool checkIsListOrNot(value) {
  return value.runtimeType.toString() == "List<String>" || value.runtimeType.toString() == "List<int>";
}
