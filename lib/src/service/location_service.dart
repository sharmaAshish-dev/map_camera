import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationService extends GetxController {
  // Observable position variable
  var currentPosition = Position(
    latitude: 0.0,
    longitude: 0.0,
    timestamp: DateTime.now(),
    accuracy: 0.0,
    altitude: 0.0,
    heading: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0,
    altitudeAccuracy: 0.0,
    headingAccuracy: 0.0,
  ).obs;

  var locationName = ''.obs;
  var subLocationName = ''.obs;

  late Worker currentLocationListener;

  // Initialize on controller creation
  @override
  void onInit() {
    super.onInit();
    requestLocationPermission();

    currentLocationListener = ever(currentPosition, (_) => getCurrentAddress);
  }

  Future<void> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Please allow from settings');
    } else if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      await getLocation();
    }
  }

  // Fetch the current location
  Future<void> getLocation() async {
    try {
      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.bestForNavigation),
      );
      currentPosition.value = position;
    } catch (e) {
      throw Exception('Error fetching location: $e');
    }
  }

  // Listen for location updates
  void getLocationUpdates() {
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 10),
    ).listen((Position position) {
      currentPosition.value = position;
    });
  }

  Future<List<Placemark>> get getCurrentAddress async {
    final placeMarks = await placemarkFromCoordinates(currentPosition.value.latitude, currentPosition.value.longitude);

    if (placeMarks.isNotEmpty) {
      locationName.value =
          "${placeMarks.first.locality ?? ""}, ${placeMarks.first.administrativeArea ?? ""}, ${placeMarks.first.country ?? ""}";

      subLocationName.value =
          "${placeMarks.first.street ?? ""}, ${placeMarks.first.thoroughfare ?? ""} ${placeMarks.first.administrativeArea ?? ""}";
    }

    return placeMarks;
  }

  @override
  void dispose() {
    currentLocationListener.dispose();
    super.dispose();
  }
}
