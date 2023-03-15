import 'package:flutter/cupertino.dart';

class PartialUpdateProvider with ChangeNotifier {
  void refresh() {
    notifyListeners();
  }
}
