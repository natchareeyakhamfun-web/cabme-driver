import 'dart:convert';
import 'dart:math';

import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/ride_satatus.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/model/user_model.dart';
import 'package:cabme_driver/service/pusher_service.dart';
import 'package:cabme_driver/utils/Preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart' as location;

import '../model/booking_mode.dart';
import '../service/api.dart';

class BookingDetailsController extends GetxController {
  RxBool isLoading = true.obs;

  RxList<Stops> locationData = <Stops>[].obs;
  Rx<TextEditingController> otpController = TextEditingController().obs;
  Rx<UserModel> userModel = UserModel().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getArgument();
    userModel.value = Constant.getUserData();

    super.onInit();
  }

  Rx<BookingData> bookingModel = BookingData().obs;

  Future<void> getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      bookingModel.value = argumentData['bookingModel'];
      setBookingData(bookingModel.value);
      await getPusherBookingData();
    }
    isLoading.value = false;
    update();
  }

  Future<void> getPusherBookingData() async {
    if (bookingModel.value.statut == RideStatus.newRide || bookingModel.value.statut == RideStatus.confirmed || bookingModel.value.statut == RideStatus.onRide) {
      PusherService().subscribeToRideEvent<BookingModel>(
        rideId: bookingModel.value.id.toString(),
        event: 'updated',
        fromJson: BookingModel.fromJson,
        onData: (ride) {
          setBookingData(ride.data!);
        },
      );
    }

    Map<String, dynamic> bodyParams = {
      'id_ride': bookingModel.value.id,
    };

    await API.handleApiRequest(request: () => http.post(Uri.parse(API.getBookingDetails), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: false).then(
      (value) async {
        if (value != null) {
          if (value['success'] == "Failed" || value['success'] == "failed") {
            ShowToastDialog.showToast(value['error'] ?? "Booking data not found");
            return null;
          } else {
            BookingModel bookingData = BookingModel.fromJson(value);
            if (bookingData.data == null) {
              ShowToastDialog.showToast("Booking data not found");
              return;
            }
            setBookingData(bookingData.data!);
          }
        }
      },
    );
  }

  void setBookingData(BookingData booking) {
    bookingModel.value = booking;
    locationData.clear();
    locationData.add(Stops(location: booking.departName, latitude: booking.latitudeDepart, longitude: booking.longitudeDepart));
    if (booking.stops != null) {
      locationData.addAll(booking.stops!.map((e) => Stops(location: e.location, latitude: e.latitude, longitude: e.longitude)));
    }
    locationData.add(Stops(location: booking.destinationName, latitude: booking.latitudeArrivee, longitude: booking.longitudeArrivee));
    calculateTotalAmount();
    calculateTotalAmount();
    if (Constant.selectedMapType == 'osm') {
      fetchRoute();
    } else {
      getPolyline();
    }
  }

  RxString subTotal = "0.0".obs;
  RxString bumpAmount = "0.0".obs;
  RxString discount = "0.0".obs;
  RxString taxAmount = "0.0".obs;
  RxString totalAmount = "0.0".obs;

  void calculateTotalAmount() {
    taxAmount = "0.0".obs;
    subTotal.value = bookingModel.value.montant.toString();
    bumpAmount.value = bookingModel.value.bumpAmount.toString();
    for (var element in bookingModel.value.tax ?? []) {
      taxAmount.value = (double.parse(taxAmount.value) + Constant().calculateTax(amount: ((double.parse(subTotal.value)) - (double.parse(discount.value))).toString(), taxModel: element))
          .toStringAsFixed(int.tryParse(Constant.decimal.toString()) ?? 2);
    }
    if (bookingModel.value.discountType != null) {
      discount.value = Constant.calculateDiscountOrder(amount: subTotal.value, offerModel: bookingModel.value.discountType).toString();
    }
    totalAmount.value = ((double.parse(subTotal.value) - (double.parse(discount.value))) + double.parse(taxAmount.value)).toStringAsFixed(int.tryParse(Constant.decimal.toString()) ?? 2);
    update();
  }

  Future<void> acceptBooking(String rideId) async {
    Map<String, dynamic> bodyParams = {
      'id_driver': Preferences.getInt(Preferences.userId),
      'id_ride': rideId,
    };

    await API.handleApiRequest(request: () => http.post(Uri.parse(API.conformRide), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: true).then(
      (value) async {
        if (value != null) {
          if (value['success'] == "Failed" || value['success'] == "failed") {
            ShowToastDialog.showToast(value['error']);
            return null;
          } else {
            await getPusherBookingData();
            ShowToastDialog.showToast("Ride accepted successfully");
          }
        }
      },
    );
  }

  Future<void> onRideStatus() async {
    Map<String, dynamic> bodyParams = {
      'id_driver': Preferences.getInt(Preferences.userId),
      'id_ride': bookingModel.value.id,
      'otp': otpController.value.text.trim(),
    };

    await API.handleApiRequest(request: () => http.post(Uri.parse(API.onRideRequest), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: true).then(
      (value) async {
        if (value != null) {
          if (value['success'] == "Failed" || value['success'] == "failed") {
            ShowToastDialog.showToast(value['message']);
            return null;
          } else {
            await getPusherBookingData();
            ShowToastDialog.showToast("Ride accepted successfully");
            Get.back();
          }
        }
      },
    );
  }

  Future<void> rejectBooking(String rideId) async {
    Map<String, dynamic> bodyParams = {
      'id_driver': Preferences.getInt(Preferences.userId),
      'id_ride': rideId,
      'reason': "Driver rejected the ride",
    };

    await API.handleApiRequest(request: () => http.post(Uri.parse(API.rejectRide), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: true).then(
      (value) async {
        if (value != null) {
          if (value['success'] == "Failed" || value['success'] == "failed") {
            ShowToastDialog.showToast(value['error']);
            return null;
          } else {
            ShowToastDialog.showToast("Ride rejected successfully");
            Get.back(result: true);
          }
        }
      },
    );
  }

  Future<void> completeBooking() async {
    Map<String, dynamic> requestBody = {
      "id_ride": bookingModel.value.id,
      "id_user": bookingModel.value.user!.id,
      "id_driver": bookingModel.value.driver!.id,
      "id_payment": bookingModel.value.idPaymentMethod,
      "transaction_id": DateTime.now().microsecondsSinceEpoch.toString(),
      "discount": "0",
      "tip": "0",
    };

    await API.handleApiRequest(request: () => http.post(Uri.parse(API.completeRequest), headers: API.headers, body: jsonEncode(requestBody)), showLoader: false).then(
      (value) {
        if (value != null) {
          if (value['success'] == "Failed" || value['success'] == "ailed") {
            ShowToastDialog.showToast(value['error']);
            return null;
          } else {
            Get.back(result: true);
            Get.back(result: true);
            ShowToastDialog.showToast("Payment Successful!!");
          }
        }
      },
    );
  }

  RxMap<gmaps.PolylineId, gmaps.Polyline> polyLines = <gmaps.PolylineId, gmaps.Polyline>{}.obs;
  PolylinePoints polylinePoints = PolylinePoints(apiKey: Constant.kGoogleApiKey.toString());

  void getPolyline() async {
    if (googlePoints.length < 2) return;

    final source = googlePoints.first;
    final destination = googlePoints.last;

    if (source.latitude == 0.0 || destination.latitude == 0.0) return;

    final intermediateStops = googlePoints.length > 2 ? googlePoints.sublist(1, googlePoints.length - 1) : <gmaps.LatLng>[];

    final wayPoints = intermediateStops.map((stop) => PolylineWayPoint(location: "${stop.latitude},${stop.longitude}")).toList();

    final polylineRequest = PolylineRequest(
      origin: PointLatLng(source.latitude, source.longitude),
      destination: PointLatLng(destination.latitude, destination.longitude),
      wayPoints: wayPoints,
      mode: TravelMode.driving,
    );

    try {
      final result = await polylinePoints.getRouteBetweenCoordinates(
        request: polylineRequest,
      );

      if (result.points.isEmpty) {
        print("Polyline error: ${result.errorMessage}");
        return;
      }

      final polylineCoordinates = result.points.map((point) => gmaps.LatLng(point.latitude, point.longitude)).toList();

      _addPolyLine(polylineCoordinates);
    } catch (e) {
      print("Exception while fetching polyline: $e");
    }
  }

  void _addPolyLine(List<gmaps.LatLng> polylineCoordinates) {
    gmaps.PolylineId id = const gmaps.PolylineId("poly");
    gmaps.Polyline polyline = gmaps.Polyline(
      color: Colors.blue,
      polylineId: id,
      points: polylineCoordinates,
      consumeTapEvents: true,
      startCap: gmaps.Cap.roundCap,
      width: 6,
    );
    polyLines[id] = polyline;
  }

  Future<void> updateCameraLocation(
    gmaps.LatLng source,
    gmaps.LatLng destination,
    gmaps.GoogleMapController? mapController,
  ) async {
    if (mapController == null) return;

    gmaps.LatLngBounds bounds;

    if (source.latitude > destination.latitude && source.longitude > destination.longitude) {
      bounds = gmaps.LatLngBounds(southwest: destination, northeast: source);
    } else if (source.longitude > destination.longitude) {
      bounds = gmaps.LatLngBounds(southwest: gmaps.LatLng(source.latitude, destination.longitude), northeast: gmaps.LatLng(destination.latitude, source.longitude));
    } else if (source.latitude > destination.latitude) {
      bounds = gmaps.LatLngBounds(southwest: gmaps.LatLng(destination.latitude, source.longitude), northeast: gmaps.LatLng(source.latitude, destination.longitude));
    } else {
      bounds = gmaps.LatLngBounds(southwest: source, northeast: destination);
    }

    gmaps.CameraUpdate cameraUpdate = gmaps.CameraUpdate.newLatLngBounds(bounds, 10);

    return checkCameraLocation(cameraUpdate, mapController);
  }

  Future<void> checkCameraLocation(gmaps.CameraUpdate cameraUpdate, gmaps.GoogleMapController mapController) async {
    mapController.animateCamera(cameraUpdate);
    gmaps.LatLngBounds l1 = await mapController.getVisibleRegion();
    gmaps.LatLngBounds l2 = await mapController.getVisibleRegion();

    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90) {
      return checkCameraLocation(cameraUpdate, mapController);
    }
  }

  gmaps.GoogleMapController? googleMapController;

  List<location.LatLng> get osmPoints => locationData.map((e) => location.LatLng(double.parse(e.latitude!), double.parse(e.longitude!))).toList();

  List<gmaps.LatLng> get googlePoints => locationData.map((e) => gmaps.LatLng(double.parse(e.latitude!), double.parse(e.longitude!))).toList();

  RxList<location.LatLng> routePoints = <location.LatLng>[].obs;
  Future<void> fetchRoute() async {
    try {
      final allCoordinates = [
        ...osmPoints.map((stop) => '${stop.longitude},${stop.latitude}'),
      ];

      final url = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/${allCoordinates.join(';')}?overview=full&geometries=geojson',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final geometry = decoded['routes'][0]['geometry']['coordinates'];

        routePoints.clear();
        for (var coord in geometry) {
          final lon = coord[0];
          final lat = coord[1];
          routePoints.add(location.LatLng(lat, lon));
        }
        update();
      } else {
        print("Failed to get route: ${response.body}");
      }
    } catch (e) {
      print("Error fetching route: $e");
    }
  }

  void fitGoogleBounds() {
    if (locationData.length < 2) return;

    final bounds = gmaps.LatLngBounds(
      southwest: gmaps.LatLng(
        locationData.map((e) => double.parse(e.latitude!)).reduce(min),
        locationData.map((e) => double.parse(e.longitude!)).reduce(min),
      ),
      northeast: gmaps.LatLng(
        locationData.map((e) => double.parse(e.latitude!)).reduce(max),
        locationData.map((e) => double.parse(e.longitude!)).reduce(max),
      ),
    );

    googleMapController?.animateCamera(
      gmaps.CameraUpdate.newLatLngBounds(bounds, 60),
    );
  }
}
