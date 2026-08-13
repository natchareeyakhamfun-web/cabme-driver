import 'dart:convert';
import 'dart:math';

import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/model/parcel_bokking_model.dart';
import 'package:cabme_driver/model/user_model.dart';
import 'package:cabme_driver/service/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart' as location;
import 'package:latlong2/latlong.dart';

import '../model/booking_mode.dart';

class ParcelDetailsController extends GetxController {
  RxBool isLoading = true.obs;

  Rx<ParcelBookingData> parcelBookingData = ParcelBookingData().obs;
  RxList<Stops> locationData = <Stops>[].obs;
  Rx<UserModel> userModel = UserModel().obs;

  @override
  void onInit() {
    userModel.value = Constant.getUserData();

    getArgument();
    // TODO: implement onInit
    super.onInit();
  }

  Future<void> getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      parcelBookingData.value = argumentData['parcelBookingData'];
      setBookingData(parcelBookingData.value);
      getParcelBookingData();
    }
    isLoading.value = false;
  }

  Future<void> getParcelBookingData() async {
    Map<String, dynamic> bodyParams = {
      'id_parcel': parcelBookingData.value.id,
    };

    print(bodyParams);
    await API.handleApiRequest(request: () => http.post(Uri.parse(API.getParcelDetail), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: false).then(
      (value) async {
        if (value != null) {
          if (value['success'] == "Failed" || value['success'] == "failed") {
            ShowToastDialog.showToast(value['error'] ?? "Booking data not found");
            return null;
          } else {
            ParcelBookingModel bookingData = ParcelBookingModel.fromJson(value);
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

  void setBookingData(ParcelBookingData booking) {
    parcelBookingData.value = booking;
    locationData.clear();
    locationData.add(Stops(location: booking.source, latitude: booking.latSource, longitude: booking.lngSource));
    locationData.add(Stops(location: booking.destination, latitude: booking.latDestination, longitude: booking.lngDestination));
    calculateTotalAmount();
    if (Constant.selectedMapType == 'osm') {
      fetchRoute();
    } else {
      getPolyline();
    }
  }

  RxString subTotal = "0.0".obs;
  RxString discount = "0.0".obs;
  RxString taxAmount = "0.0".obs;
  RxString totalAmount = "0.0".obs;

  void calculateTotalAmount() {
    taxAmount = "0.0".obs;
    subTotal.value = parcelBookingData.value.amount.toString();
    if (parcelBookingData.value.discountType != null) {
      discount.value = Constant.calculateDiscountOrder(amount: subTotal.value, offerModel: parcelBookingData.value.discountType).toString();
    }
    for (var element in parcelBookingData.value.tax!) {
      taxAmount.value = (double.parse(taxAmount.value) + Constant().calculateTax(amount: (double.parse(subTotal.value) - double.parse(discount.value)).toString(), taxModel: element))
          .toStringAsFixed(int.tryParse(Constant.decimal.toString()) ?? 2);
    }

    totalAmount.value = ((double.parse(subTotal.value) - (double.parse(discount.value))) + double.parse(taxAmount.value)).toStringAsFixed(int.tryParse(Constant.decimal.toString()) ?? 2);
    update();
  }



  gmaps.GoogleMapController? googleMapController;

  List<LatLng> get osmPoints => locationData.map((e) => LatLng(double.parse(e.latitude!), double.parse(e.longitude!))).toList();
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

  RxMap<gmaps.PolylineId, gmaps.Polyline> polyLines = <gmaps.PolylineId, gmaps.Polyline>{}.obs;
  PolylinePoints polylinePoints = PolylinePoints(apiKey: Constant.kGoogleApiKey.toString());

  void getPolyline() async {
    if (googlePoints.length < 2) return;

    final source = googlePoints.first;
    final destination = googlePoints.last;

    if (source.latitude == 0.0 || destination.latitude == 0.0) return;

    final intermediateStops = googlePoints.length > 2 ? googlePoints.sublist(1, googlePoints.length - 1) : <gmaps.LatLng>[];
    [];

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

  List<gmaps.LatLng> get googlePoints => locationData.map((e) => gmaps.LatLng(double.parse(e.latitude!), double.parse(e.longitude!))).toList();

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
