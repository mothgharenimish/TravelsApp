import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// state is the city name when location access is on, or null when it's off.
class LocationCubit extends Cubit<String?> {
  LocationCubit() : super(null);

  Future<String?> getCurrentLocationAndSave() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );

      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
      String city = placemarks.first.locality ?? "Unknown";

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_city', city);

      emit(city);
      return city;
    } catch (e) {
      return null;
    }
  }

  Future<void> clearSavedCity() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_city');
    emit(null);
  }

  /// Call on app start to load whatever city was last saved.
  Future<void> loadSavedState() async {
    final prefs = await SharedPreferences.getInstance();
    final city = prefs.getString('current_city');
    emit(city);
  }
}