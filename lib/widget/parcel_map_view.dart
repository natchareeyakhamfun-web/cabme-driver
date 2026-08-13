import 'dart:io';

import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/controller/parcel_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

class ParcelMapView extends StatefulWidget {
  const ParcelMapView({super.key});
  @override
  State<ParcelMapView> createState() => _MapViewState();
}

class _MapViewState extends State<ParcelMapView> {
  final controller = Get.find<ParcelDetailsController>();
  final GlobalKey osmMapKey = GlobalKey();
  late final MapController flutterMapController;

  @override
  void initState() {
    super.initState();
    flutterMapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Constant.selectedMapType == "google" ? googleMap() : osmMap());
  }

  Widget googleMap() {
    return gmaps.GoogleMap(
      initialCameraPosition: gmaps.CameraPosition(
        target: controller.googlePoints.first,
        zoom: 14,
      ),
      onMapCreated: (mapCtrl) {
        controller.googleMapController = mapCtrl;
        controller.fitGoogleBounds();
      },
      markers: controller.googlePoints
          .map((e) => gmaps.Marker(
                markerId: gmaps.MarkerId("${e.latitude},${e.longitude}"),
                position: e,
              ))
          .toSet(),
      polylines: controller.polyLines.values.toSet(),
    );
  }

  Widget osmMap() {
    return Stack(
      children: [
        RepaintBoundary(
          key: osmMapKey,
          child: FlutterMap(
            mapController: flutterMapController,
            options: MapOptions(
              initialCenter: controller.osmPoints.first,
              initialZoom: 13,
              onMapReady: () {
                final bounds = LatLngBounds.fromPoints(controller.osmPoints);
                flutterMapController.fitCamera(
                  CameraFit.bounds(bounds: bounds, padding: EdgeInsets.all(40)),
                );
              },
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: Platform.isAndroid ? "com.cabme.driver" : "com.cabme.driver.ios",
              ),
              if (controller.routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: controller.routePoints,
                      color: Colors.red,
                      strokeWidth: 4,
                    ),
                  ],
                ),
              MarkerLayer(
                markers: controller.osmPoints.map(
                  (p) {
                    return Marker(
                      point: p,
                      width: 30,
                      height: 30,
                      child: Icon(Icons.location_on, color: Colors.black),
                    );
                  },
                ).toList(),
              )
            ],
          ),
        ),
      ],
    );
  }
}
