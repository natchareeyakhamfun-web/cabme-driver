import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/ride_satatus.dart';
import 'package:cabme_driver/model/booking_mode.dart';
import 'package:cabme_driver/model/user_model.dart';
import 'package:cabme_driver/service/api.dart';
import 'package:cabme_driver/service/pusher_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as flutterMap;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart' as latlong;
import 'package:latlong2/latlong.dart' as location;

class LiveTrackingController extends GetxController {
  GoogleMapController? mapController;
  final flutterMap.MapController mapOsmController = flutterMap.MapController();

  @override
  void onInit() {
    // TODO: implement onInit
    getArgument();
    super.onInit();
  }

  Rx<BookingData> orderModel = BookingData().obs;
  Rx<UserModel> driverUserModel = UserModel().obs;
  RxBool isLoading = true.obs;

  Rx<latlong.LatLng> source = latlong.LatLng(21.1702, 72.8311).obs; // Start (e.g., Surat)
  Rx<latlong.LatLng> current = latlong.LatLng(21.1800, 72.8400).obs; // Moving marker
  Rx<latlong.LatLng> destination = latlong.LatLng(21.2000, 72.8600).obs; // Destination

  Future<void> getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      orderModel.value = argumentData['orderModel'];
      await getDriverDetails();

      PusherService().subscribeToRideEvent<BookingData>(
        rideId: orderModel.value.id.toString(),
        event: 'updated',
        fromJson: BookingData.fromJson,
        onData: (ride) {
          orderModel.value = ride;
        },
      );

      PusherService().subscribeToDriverEvent<UserModel>(
        driverId: orderModel.value.driver!.id.toString(),
        event: 'updated',
        fromJson: UserModel.fromJson,
        onData: (ride) {
          driverUserModel.value = ride;
          setData();
        },
      );
    }
    addMarkerSetup();

    isLoading.value = false;

    update();
  }

  Future<void> getDriverDetails() async {
    Map<String, dynamic> bodyParams = {
      'id_driver': orderModel.value.driver!.id.toString(),
    };

    await API
        .handleApiRequest(
        request: () => http.post(Uri.parse(API.getDriverDetails), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: false)
        .then(
          (value) async {
        if (value != null) {
          if (value['success'] == "Failed" || value['success'] == "failed") {
            return null;
          } else {
            driverUserModel.value = UserModel.fromJson(value);
            update();
            setData();
          }
        }
      },
    );
  }

  void setData() {
    if (Constant.selectedMapType != 'osm') {
      if (orderModel.value.statut == RideStatus.confirmed) {
        getPolyline(
            sourceLatitude: double.parse(driverUserModel.value.userData!.latitude.toString()),
            sourceLongitude: double.parse(driverUserModel.value.userData!.longitude.toString()),
            destinationLatitude: double.parse(orderModel.value.latitudeDepart.toString()),
            destinationLongitude: double.parse(orderModel.value.longitudeDepart.toString()));
      } else if (orderModel.value.statut == RideStatus.onRide) {
        getPolyline(
            sourceLatitude: double.parse(driverUserModel.value.userData!.latitude.toString()),
            sourceLongitude: double.parse(driverUserModel.value.userData!.longitude.toString()),
            destinationLatitude: double.parse(orderModel.value.latitudeArrivee.toString()),
            destinationLongitude: double.parse(orderModel.value.longitudeArrivee.toString()));
      }else{
        getPolyline(
            sourceLatitude: double.parse(orderModel.value.latitudeDepart.toString()),
            sourceLongitude: double.parse(orderModel.value.longitudeDepart.toString()),
            destinationLatitude: double.parse(orderModel.value.latitudeArrivee.toString()),
            destinationLongitude: double.parse(orderModel.value.longitudeArrivee.toString()));
      }
    } else {
      print("OSM Map Type");
      if (orderModel.value.statut == RideStatus.confirmed) {
        current.value = location.LatLng(double.parse('${driverUserModel.value.userData!.latitude ?? 0.0}'),
            double.parse('${driverUserModel.value.userData!.longitude ?? 0.0}'));
        source.value = location.LatLng(
            double.parse(orderModel.value.latitudeDepart.toString()), double.parse(orderModel.value.longitudeDepart.toString()));
        destination.value = location.LatLng(
            double.parse(orderModel.value.latitudeArrivee.toString()), double.parse(orderModel.value.longitudeArrivee.toString()));
        fetchRoute(current.value, source.value);
        animateToSource();
      } else if (orderModel.value.statut == RideStatus.onRide) {
        current.value = location.LatLng(double.parse('${driverUserModel.value.userData?.latitude ?? 0.0}'),
            double.parse('${driverUserModel.value.userData?.longitude ?? 0.0}'));
        source.value = location.LatLng(
            double.parse(orderModel.value.latitudeDepart.toString()), double.parse(orderModel.value.longitudeDepart.toString()));
        destination.value = location.LatLng(
            double.parse(orderModel.value.latitudeArrivee.toString()), double.parse(orderModel.value.longitudeArrivee.toString()));
        fetchRoute(current.value, destination.value);
        animateToSource();
      } else {
        current.value = location.LatLng(double.parse('${driverUserModel.value.userData?.latitude ?? 0.0}'),
            double.parse('${driverUserModel.value.userData?.longitude ?? 0.0}'));
        source.value = location.LatLng(
            double.parse(orderModel.value.latitudeDepart.toString()), double.parse(orderModel.value.longitudeDepart.toString()));
        destination.value = location.LatLng(
            double.parse(orderModel.value.latitudeArrivee.toString()), double.parse(orderModel.value.longitudeArrivee.toString()));
        fetchRoute(current.value, source.value);
        animateToSource();
      }
    }
    update();
  }

  void animateToSource() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mapOsmController.move(
        location.LatLng(double.parse('${driverUserModel.value.userData?.latitude ?? Constant.currentLocation!.latitude}'),
            double.parse('${driverUserModel.value.userData?.longitude ?? Constant.currentLocation!.latitude}')),
        16,
      );
    });
  }

  RxList<latlong.LatLng> routePoints = <latlong.LatLng>[].obs;

  Future<void> fetchRoute(location.LatLng source, location.LatLng destination) async {
    final url = Uri.parse(
      'https://router.project-osrm.org/route/v1/driving/${source.longitude},${source.latitude};${destination.longitude},${destination.latitude}?overview=full&geometries=geojson',
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
    } else {
      print("Failed to get route: ${response.body}");
    }
  }

  BitmapDescriptor? departureIcon;
  BitmapDescriptor? destinationIcon;
  BitmapDescriptor? driverIcon;

  void getPolyline(
      {required double? sourceLatitude,
        required double? sourceLongitude,
        required double? destinationLatitude,
        required double? destinationLongitude}) async {
    if (sourceLatitude != null && sourceLongitude != null && destinationLatitude != null && destinationLongitude != null) {
      List<LatLng> polylineCoordinates = [];
      PolylineRequest polylineRequest = PolylineRequest(
        origin: PointLatLng(sourceLatitude, sourceLongitude),
        destination: PointLatLng(destinationLatitude, destinationLongitude),
        mode: TravelMode.driving,
      );

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        request: polylineRequest,
      );
      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      } else {
        print(result.errorMessage.toString());
      }
      if (orderModel.value.statut == RideStatus.confirmed) {
        addMarker(
            latitude: double.parse(driverUserModel.value.userData!.latitude.toString()),
            longitude: double.parse(driverUserModel.value.userData!.longitude.toString()),
            id: "Driver",
            descriptor: driverIcon!,
            rotation: 0.0);
        addMarker(
          latitude: double.parse(orderModel.value.latitudeDepart.toString()),
          longitude: double.parse(orderModel.value.longitudeDepart.toString()),
          id: "Departure",
          descriptor: departureIcon!,
          rotation: 0.0,
        );
      } else if (orderModel.value.statut == RideStatus.onRide) {
        addMarker(
            latitude: double.parse(driverUserModel.value.userData!.latitude.toString()),
            longitude: double.parse(driverUserModel.value.userData!.longitude.toString()),
            id: "Driver",
            descriptor: driverIcon!,
            rotation: 0.0);
        addMarker(
            latitude: double.parse(orderModel.value.latitudeArrivee.toString()),
            longitude: double.parse(orderModel.value.longitudeArrivee.toString()),
            id: "Destination",
            descriptor: destinationIcon!,
            rotation: 0.0);
      }else{
        addMarker(
            latitude: double.parse(orderModel.value.latitudeDepart.toString()),
            longitude: double.parse(orderModel.value.longitudeDepart.toString()),
            id: "Departure",
            descriptor: departureIcon!,
            rotation: 0.0);
        addMarker(
            latitude: double.parse(orderModel.value.latitudeArrivee.toString()),
            longitude: double.parse(orderModel.value.longitudeArrivee.toString()),
            id: "Destination",
            descriptor: destinationIcon!,
            rotation: 0.0);
      }

      _addPolyLine(polylineCoordinates);
    }
  }

  RxMap<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;

  void addMarker(
      {required double? latitude,
        required double? longitude,
        required String id,
        required BitmapDescriptor descriptor,
        required double? rotation}) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
    Marker(markerId: markerId, icon: descriptor, position: LatLng(latitude ?? 0.0, longitude ?? 0.0), rotation: rotation ?? 0.0);
    markers[markerId] = marker;
  }

  Future<void> addMarkerSetup() async {
    if (Constant.selectedMapType != 'osm') {
      final Uint8List departure = await Constant.getBytesFromAsset('assets/icons/ic_souce.png', 100);
      final Uint8List destination = await Constant.getBytesFromAsset('assets/icons/ic_destination.png', 100);
      final Uint8List driver = await Constant.getBytesFromAsset('assets/icons/ic_taxi.png', 100);
      departureIcon = BitmapDescriptor.fromBytes(departure);
      destinationIcon = BitmapDescriptor.fromBytes(destination);
      driverIcon = BitmapDescriptor.fromBytes(driver, size: Size(100.0, 100.0));
    }
  }

  RxMap<PolylineId, Polyline> polyLines = <PolylineId, Polyline>{}.obs;
  PolylinePoints polylinePoints = PolylinePoints(apiKey: Constant.kGoogleApiKey.toString());

  void _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      color: Colors.blue,
      polylineId: id,
      points: polylineCoordinates,
      consumeTapEvents: true,
      startCap: Cap.roundCap,
      width: 6,
    );
    polyLines[id] = polyline;
    updateCameraLocation(polylineCoordinates.first, polylineCoordinates.last, mapController);
  }

  Future<void> updateCameraLocation(
      LatLng source,
      LatLng destination,
      GoogleMapController? mapController,
      ) async {
    if (mapController == null) return;

    LatLngBounds bounds;

    if (source.latitude > destination.latitude && source.longitude > destination.longitude) {
      bounds = LatLngBounds(southwest: destination, northeast: source);
    } else if (source.longitude > destination.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(source.latitude, destination.longitude), northeast: LatLng(destination.latitude, source.longitude));
    } else if (source.latitude > destination.latitude) {
      bounds = LatLngBounds(
          southwest: LatLng(destination.latitude, source.longitude), northeast: LatLng(source.latitude, destination.longitude));
    } else {
      bounds = LatLngBounds(southwest: source, northeast: destination);
    }

    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 10);

    return checkCameraLocation(cameraUpdate, mapController);
  }

  Future<void> checkCameraLocation(CameraUpdate cameraUpdate, GoogleMapController mapController) async {
    mapController.animateCamera(cameraUpdate);
    LatLngBounds l1 = await mapController.getVisibleRegion();
    LatLngBounds l2 = await mapController.getVisibleRegion();

    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90) {
      return checkCameraLocation(cameraUpdate, mapController);
    }
  }

}
