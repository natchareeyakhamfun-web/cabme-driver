import 'package:cabme_driver/widget/place_picker/selected_location_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  /// Get Current Location (Latitude & Longitude)
  static Future<Position?> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(locationSettings: LocationSettings(accuracy: LocationAccuracy.high));

      return position;
    } catch (e) {
      print("Error getting location: $e");
    }
    return null;
  }

  static Future<void> sendSMS({required String phoneNumber, required String message}) async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: <String, String>{
        'body': message,
      },
    );
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      throw 'Could not launch SMS';
    }
  }

  static Future<void> launchURL(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> dialPhoneNumber(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  static String formatAddress({required SelectedLocationModel selectedLocation}) {
    List<String> parts = [];

    if (selectedLocation.address!.name != null && selectedLocation.address!.name!.isNotEmpty) parts.add(selectedLocation.address!.name!);
    if (selectedLocation.address!.subThoroughfare != null && selectedLocation.address!.subThoroughfare!.isNotEmpty) parts.add(selectedLocation.address!.subThoroughfare!);
    if (selectedLocation.address!.thoroughfare != null && selectedLocation.address!.thoroughfare!.isNotEmpty) parts.add(selectedLocation.address!.thoroughfare!);
    if (selectedLocation.address!.subLocality != null && selectedLocation.address!.subLocality!.isNotEmpty) parts.add(selectedLocation.address!.subLocality!);
    if (selectedLocation.address!.locality != null && selectedLocation.address!.locality!.isNotEmpty) parts.add(selectedLocation.address!.locality!);
    if (selectedLocation.address!.subAdministrativeArea != null && selectedLocation.address!.subAdministrativeArea!.isNotEmpty) parts.add(selectedLocation.address!.subAdministrativeArea!);
    if (selectedLocation.address!.administrativeArea != null && selectedLocation.address!.administrativeArea!.isNotEmpty) parts.add(selectedLocation.address!.administrativeArea!);
    if (selectedLocation.address!.postalCode != null && selectedLocation.address!.postalCode!.isNotEmpty) parts.add(selectedLocation.address!.postalCode!);
    if (selectedLocation.address!.country != null && selectedLocation.address!.country!.isNotEmpty) parts.add(selectedLocation.address!.country!);
    if (selectedLocation.address!.isoCountryCode != null && selectedLocation.address!.isoCountryCode!.isNotEmpty) parts.add(selectedLocation.address!.isoCountryCode!);

    return parts.join(', ');
  }

}
