import 'dart:io';

import 'package:cabme_driver/themes/round_button_fill.dart';
import 'package:cabme_driver/utils/dark_theme_provider.dart';
import 'package:cabme_driver/widget/osm_map/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../themes/app_them_data.dart';

class MapPickerPage extends StatelessWidget {
  final OSMMapController controller = Get.put(OSMMapController());
  final TextEditingController searchController = TextEditingController();

  MapPickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          Obx(
            () => FlutterMap(
              mapController: controller.mapController,
              options: MapOptions(
                initialCenter: controller.pickedPlace.value?.coordinates ??
                    const LatLng(20.5937, 78.9629), // Default India center
                 initialZoom: 13,
                onTap: (tapPos, latlng) {
                  controller.addLatLngOnly(latlng);
                  controller.mapController.move(latlng, controller.mapController.camera.zoom);
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: Platform.isAndroid
                      ? "com.cabme.driver"
                      : "com.cabme.driver.ios",
                ),
                MarkerLayer(
                  markers: controller.pickedPlace.value != null
                      ? [
                          Marker(
                            point: controller.pickedPlace.value!.coordinates,
                            width: 40,
                            height: 40,
                            child: const Icon(
                              Icons.location_pin,
                              size: 36,
                              color: Colors.red,
                            ),
                          ),
                        ]
                      : [],
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: themeChange.getThem() ? AppThemeData.neutralDark50 : AppThemeData.neutral50,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: SvgPicture.asset("assets/icons/ic_back.svg",
                          color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(30),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search location...'.tr,
                      contentPadding: EdgeInsets.all(12),
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: controller.searchPlace,
                  ),
                ),
                Obx(() {
                  if (controller.searchResults.isEmpty) return const SizedBox.shrink();

                  return Container(
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: themeChange.getThem() ? AppThemeData.neutralDark50 : AppThemeData.neutral50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: controller.searchResults.length,
                      itemBuilder: (context, index) {
                        final place = controller.searchResults[index];
                        return ListTile(
                          title: Text(
                            place['display_name'],
                            style: TextStyle(color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                          ),
                          onTap: () {
                            controller.selectSearchResult(place);
                            final lat = double.parse(place['lat']);
                            final lon = double.parse(place['lon']);
                            final pos = LatLng(lat, lon);
                            controller.mapController.move(pos, 15);
                            searchController.text = place['display_name'];
                          },
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(() {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 26),
          color: themeChange.getThem() ? AppThemeData.neutralDark50 : AppThemeData.neutral50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                controller.pickedPlace.value != null ? "Picked Location:".tr : "No Location Picked".tr,
                style: TextStyle(
                  color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                  fontFamily: AppThemeData.semibold,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              if (controller.pickedPlace.value != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text(
                    "${controller.pickedPlace.value!.address}\n(${controller.pickedPlace.value!.coordinates.latitude.toStringAsFixed(5)}, ${controller.pickedPlace.value!.coordinates.longitude.toStringAsFixed(5)})",
                    style: TextStyle(fontSize: 13, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                  ),
                ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: RoundedButtonFill(
                      title: "Confirm Location".tr,
                      height: 5.5,
                      color: AppThemeData.primaryDefault,
                      textColor: AppThemeData.neutral50,
                      onPress: () async {
                        FocusScope.of(context).unfocus();
                        final selected = controller.pickedPlace.value;
                        if (selected != null) {
                          Get.back(result: selected); // ✅ Return the selected place
                          print("Selected location: $selected");
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.delete_forever, color: Colors.red),
                    onPressed: controller.clearAll,
                  )
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
