import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Searchable {
  String get firstTile;
  String get secondTile;
  String get thirdTile;
  String get iconTile;
  bool find(String value,double startRate,double endRate,GeoPoint currentLocation,double distance);
}
