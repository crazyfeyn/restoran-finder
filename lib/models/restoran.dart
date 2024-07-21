import 'package:geolocator/geolocator.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class Restoran {
  String restaurantName;
  String locationName;
  Point latLng;
  String imageUrl;

  Restoran(
      {required this.restaurantName,
      required this.locationName,
      required this.latLng, required this.imageUrl});
}
