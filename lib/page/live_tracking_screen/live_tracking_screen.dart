import 'dart:io';

import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/controller/live_tracking_controller.dart';
import 'package:cabme_driver/themes/app_them_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as flutterMap;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart' as latlong;

class LiveTrackingScreen extends StatelessWidget {
  const LiveTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<LiveTrackingController>(
      init: LiveTrackingController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            elevation: 2,
            backgroundColor: AppThemeData.primaryDefault,
            title: Text("Map view".tr),
            leading: InkWell(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  Icons.arrow_back,
                )),
          ),
          body: controller.isLoading.value
              ? Constant.loader(context)
              : Constant.selectedMapType == 'osm'
              ? flutterMap.FlutterMap(
            mapController: controller.mapOsmController,
            options: flutterMap.MapOptions(
              initialCenter: latlong.LatLng(41.4219057, -102.0840772),
              initialZoom: 10,
            ),
            children: [
              flutterMap.TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: Platform.isAndroid ? "com.cabme" : "com.cabme.ios",
              ),
              flutterMap.MarkerLayer(
                markers: [
                  flutterMap.Marker(
                    point: controller.current.value,
                    width: 50,
                    height: 50,
                    child: Image.asset('assets/images/ic_taxi.png'),
                  ),
                  flutterMap.Marker(
                    point: controller.source.value,
                    width: 50,
                    height: 50,
                    child: Image.asset('assets/icons/pickup.png'),
                  ),
                  flutterMap.Marker(
                    point: controller.destination.value,
                    width: 50,
                    height: 50,
                    child: Image.asset('assets/icons/dropoff.png'),
                  ),
                ],
              ),
              if (controller.routePoints.isNotEmpty)
                flutterMap.PolylineLayer(
                  polylines: [
                    flutterMap.Polyline(
                      points: controller.routePoints,
                      strokeWidth: 5.0,
                      color: Colors.blue,
                    ),
                  ],
                ),
            ],
          )
              : Obx(
                () => GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.terrain,
              zoomControlsEnabled: false,
              polylines: Set<Polyline>.of(controller.polyLines.values),
              padding: const EdgeInsets.only(
                top: 22.0,
              ),
              markers: Set<Marker>.of(controller.markers.values),
              onMapCreated: (GoogleMapController mapController) {
                controller.mapController = mapController;
              },
              initialCameraPosition: CameraPosition(
                zoom: 15,
                target: LatLng(Constant.currentLocation != null ? Constant.currentLocation!.latitude : 45.521563,
                    Constant.currentLocation != null ? Constant.currentLocation!.longitude : -122.677433),
              ),
            ),
          ),
        );
      },
    );
  }
}
