import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

import 'SecurityDashbordController.dart';
import '../../../Services/ApiServices/GlobalLoader.dart';
import '../../../Model/HotelPlaceModel.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final SecurityDashbordController controller = Get.put(SecurityDashbordController());

  GoogleMapController? mapController;
  List<HotelMapData> hotelPlaceList = [];
  Set<Marker> _markers = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to ensure context is available for the loader
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getMapWiseHotelListApi();
    });
  }

  // ========================= API & DATA PROCESSING =========================

  Future<void> getMapWiseHotelListApi() async {
    setState(() => _isLoading = true);
    showLoader(context);

    try {
      debugPrint("--- Fetching Hotel Data ---");
      HotelPlaceModel? data = await controller.getMapHotelListData();

      if (data != null && data.trips != null && data.trips!.isNotEmpty) {
        debugPrint("Data received: ${data.trips!.length} trips found.");

        setState(() {
          hotelPlaceList = data.trips!;



        });

        // Start geocoding markers in the background
        await _prepareMarkers();
      } else {
        debugPrint("No trips found in the API response.");
      }
    } catch (e) {
      debugPrint("Error fetching API: $e");
    } finally {
      dismissLoader(context);
      setState(() => _isLoading = false);
    }
  }

  Future<void> _prepareMarkers() async {
    Set<Marker> tempMarkers = {};

    for (var item in hotelPlaceList) {
      if (item.members != null && item.members!.isNotEmpty) {
        final member = item.members![0];
        final hotelName = member.hotel ?? "";
        final cityName = member.HotelCityName ?? "";

        if (hotelName.isNotEmpty) {
          debugPrint("Geocoding: $hotelName, $cityName");
          LatLng? latLng = await _getLatLngFromAddress("$hotelName, $cityName");

          if (latLng != null) {
            tempMarkers.add(
              Marker(
                markerId: MarkerId(item.bookingID.toString()),
                position: latLng,
                infoWindow: InfoWindow(title: hotelName, snippet: cityName),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
              ),
            );
          }
        }
      }
    }

    if (mounted) {
      setState(() {
        _markers = tempMarkers;
        debugPrint("Total Markers Created: ${_markers.length}");
      });
    }
  }

  Future<LatLng?> _getLatLngFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        return LatLng(locations.first.latitude, locations.first.longitude);
      }
    } catch (e) {
      debugPrint("Geocoding failed for $address: $e");
    }
    return null;
  }

  // ========================= UI COMPONENTS =========================

  void showMapBottomSheet() {
    if (_markers.isEmpty) {
      Get.snackbar("Notice", "Map markers are still loading or could not be located.",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _mapSheetInternal(),
    );
  }

  Widget _mapSheetInternal() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(height: 5, width: 40, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text("Trip Locations", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(target: LatLng(22.9734, 78.6569), zoom: 5),
              markers: _markers,
              onMapCreated: (GoogleMapController ctrl) {
                mapController = ctrl;
                _zoomToFit();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _zoomToFit() {
    if (mapController == null || _markers.isEmpty) return;

    LatLngBounds bounds;
    double minLat = _markers.first.position.latitude;
    double maxLat = minLat;
    double minLng = _markers.first.position.longitude;
    double maxLng = minLng;

    for (var m in _markers) {
      if (m.position.latitude < minLat) minLat = m.position.latitude;
      if (m.position.latitude > maxLat) maxLat = m.position.latitude;
      if (m.position.longitude < minLng) minLng = m.position.longitude;
      if (m.position.longitude > maxLng) maxLng = m.position.longitude;
    }

    bounds = LatLngBounds(southwest: LatLng(minLat, minLng), northeast: LatLng(maxLat, maxLng));
    mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Trips"),
        actions: [
          if (hotelPlaceList.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.map_outlined),
              onPressed: showMapBottomSheet,
            )
        ],
      ),
      body: _isLoading
          ? const SizedBox.shrink() // Loader is shown via GlobalLoader
          : hotelPlaceList.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.not_listed_location_outlined, size: 60, color: Colors.grey),
            const SizedBox(height: 10),
            const Text("No trips found in your account.", style: TextStyle(color: Colors.grey)),
            TextButton(onPressed: getMapWiseHotelListApi, child: const Text("Retry"))
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: hotelPlaceList.length,
        itemBuilder: (context, index) {
          final item = hotelPlaceList[index];
          final member = (item.members != null && item.members!.isNotEmpty) ? item.members![0] : null;

          return Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.hotel)),
              title: Text(member?.hotel ?? "Unknown Hotel"),
              subtitle: Text(member?.HotelCityName ?? "No City Info"),
              trailing: const Icon(Icons.chevron_right),
            ),
          );
        },
      ),
    );
  }
}