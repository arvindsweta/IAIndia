import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:myfirstdemo/Model/HotelListModel.dart';
import 'package:myfirstdemo/Model/HotelPlaceModel.dart';
import 'package:myfirstdemo/Model/TripWrapper.dart';
import 'package:myfirstdemo/Services/ApiServices/GlobalLoader.dart';
import 'package:myfirstdemo/Services/ApiServices/SecureStorageService.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myfirstdemo/UI/LoginScreen/SignInView.dart';
import 'package:myfirstdemo/UI/SecurityDashboard/MenuDrawer/MapScreen.dart';
import 'package:myfirstdemo/Widgets/CustomWidgets.dart';


import '../../../Model/VerifyOtpResponse.dart';
import '../../../constants/Assets.dart';
import 'SecurityDashbordController.dart';
import 'package:get/get.dart';
class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {

  late final SecurityDashbordController securityDashbordController = Get.put(SecurityDashbordController());
  final SecureStorageService _storageService = SecureStorageService();
  final TextEditingController searchController = TextEditingController();
  GoogleMapController? mapController;
  // 1. Keep track of the currently selected page
  int _selectedIndex = 0;
  String? selectMenu = "Hotel List";
  DateTime? _fromDate;
  DateTime? _toDate;

  List<HotelMapData> hotePlacelList = [];
  List<HotelMapData> filterhotePlacelList = [];

  Set<Marker> _markers = {};
  String? username = "";
  String? companyName = "";
  String? division = "";

  void _onItemTapped(int index) {
    setState(() {

      print("====>");

      if(index == 0)
        {
          selectMenu = "Trip Map";
          //getMapWiseHotelListApi();
        }

        else{
        Future.delayed(Duration(milliseconds: 2), () {

          _storageService.logout();

          Navigator.pushAndRemoveUntil(
              context,
              MaterialWithModalsPageRoute(builder: (context) => SignInView()),
                  (Route<dynamic> route) => false);
        });
      }


    });
    Navigator.pop(context); // 3. Close the drawer after selection
  }


  @override
  void initState() {
    getUserData();
    getMapWiseHotelListApi();
    super.initState();

  }









  getHotelChangeStatusApi() async {
    showLoader(context);
    try {
      VerifyOtpResponse? dataModel = await securityDashbordController.hotelActiveInActiveApi(useId:"",hotelId: "",Status:"" );

      if (mounted) {
        dismissLoader(context);
        await Future.delayed(const Duration(milliseconds: 100));

        if (dataModel != null) {


          // If the server returns trips, it's a success

        }
      }
    } catch (e) {
      print("Error in postTripApi: $e");
      if (mounted) dismissLoader(context);
    }
  }


//@@@@@@@@@@@@@@@@@@


  getMapWiseHotelListApi() async {
    showLoader(context);
    try {
      HotelPlaceModel? dataModel = await securityDashbordController.getMapHotelListData();

      if (mounted) {

        if (dataModel != null && dataModel.trips != null) {

          hotePlacelList = dataModel.trips!;

          // 1. Define 'Today' at the start of the day for accurate comparison
          DateTime now = DateTime.now();
          DateTime today = DateTime(now.year, now.month, now.day);

          // 2. Filter the trips
          filterhotePlacelList = dataModel.trips!.where((trip) {
            if (trip.members == null || trip.members!.isEmpty) return false;

            // Check if ANY member in this trip is staying at the hotel today
            return trip.members!.any((member) {
              DateTime? fromDate = _parseApiDate(member.HotelFromDate);
              DateTime? toDate = _parseApiDate(member.HotelToDate);

              if (fromDate == null || toDate == null) return false;

              // Check if today is between fromDate and toDate (inclusive)
              return (today.isAtSameMomentAs(fromDate) || today.isAfter(fromDate)) &&
                  (today.isAtSameMomentAs(toDate) || today.isBefore(toDate));
            });
          }).toList();

          await _prepareMarkers();
          dismissLoader(context);
          setState(() {});
        }
      }
    } catch (e) {
      debugPrint("Error in getMapWiseHotelListApi: $e");
      if (mounted) dismissLoader(context);
    }
  }

// Helper method to handle the "DD/MM/YYYY" format coming from your API
  DateTime? _parseApiDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    try {
      // Split by space to remove any time component (e.g., "25/12/2023 00:00")
      String datePart = dateStr.split(" ")[0];
      List<String> parts = datePart.split("/");
      int day = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int year = int.parse(parts[2]);
      return DateTime(year, month, day);
    } catch (e) {
      return null;
    }
  }





 //*********




  Future<void> _filterByHotelDate() async {
    // Define the format matching your JSON: "19/08/2024 00:00:00"

    DateTime today = DateTime(_fromDate!.year, _fromDate!.month, _fromDate!.day);
    print(today.toString());
    // 2. Filter the trips
    filterhotePlacelList = hotePlacelList.where((trip) {
      if (trip.members == null || trip.members!.isEmpty) return false;

      // Check if ANY member in this trip is staying at the hotel today
      return trip.members!.any((member) {
        DateTime? fromDate = _parseApiDate(member.HotelFromDate);
        DateTime? toDate = _parseApiDate(member.HotelToDate);

        if (fromDate == null || toDate == null) return false;

        // Check if today is between fromDate and toDate (inclusive)
        return (today.isAtSameMomentAs(fromDate) || today.isAfter(fromDate)) &&
            (today.isAtSameMomentAs(toDate) || today.isBefore(toDate));
      });
    }).toList();

    print(filterhotePlacelList.length.toString());

    await _prepareMarkers();
    setState(() {});



  }




  getUserData() async {
   username = await _storageService.getUsername();
   companyName = await _storageService.getCompany();
  }


  @override
  Widget build(BuildContext context) {



    return Scaffold(


        appBar: AppBar(
          title: Text(selectMenu.toString()),
          actions: [
             IconButton(
              // Ensure your SVG is added to your assets folder and pubspec.yaml
              icon: imageView(

                assetName: Assets.MapIcone,
                fit: BoxFit.fill, // better for circular images
              ),
              onPressed: () {

               /* Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MapScreen(

                      )),
                );*/
                showMapBottomSheet();
                //announcementBottomSheet(context: context);


              },
            ),
          ],
        ),
      // 4. The Side Menu (Drawer)
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
             DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                username.toString(),
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Trip map'),
              selected: _selectedIndex == 0,
              onTap: () => _onItemTapped(0),
            ),
            /*ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Hotel list'),
              selected: _selectedIndex == 1,
              onTap: () => _onItemTapped(1),
            ),*/
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Logout'),
              selected: _selectedIndex == 1,
              onTap: () => _onItemTapped(2),
            ),
          ],
        ),
      ),
      // 5. Display the selected page
      body:Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Column(
            children: [
        // Header Row
              const Divider(height: 1),
              hotelMapListWidget()
    ])
      )
    );
  }















/*  Widget latestNewsWidget() {

    return Column(children: [

      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(width: MediaQuery.of(context).size.width*.80,height: 45,
              child:TextFormField(
                controller: searchController,
                decoration: const InputDecoration(

                  border: OutlineInputBorder(),
                  hintText: "Search ",




                ),
                onChanged:(value){
                  List<HotelItem> filteredList = [];
                  if (![null, "null", false].contains(value)) {
                    filteredList = hotelList!.where((item) {
                      return item.HotelName
                          .toString()
                          .toLowerCase()
                          .contains(value.toLowerCase()) ||
                          item.ChainName
                              .toString()
                              .toLowerCase()
                              .contains(value.toLowerCase()) || item.Place
                          .toString()
                          .toLowerCase()
                          .contains(value.toLowerCase());;
                    }).toList();
                    filterhotelList = filteredList;
                  }
                  setState(() {});
                },




            )),


          ],
        ),
      ),

      Padding(
          padding: const EdgeInsets.only(left: 0, top: 20),
          child: SizedBox(
            height:
            MediaQuery.of(context).size.height * 0.75,
            child: filterhotelList!.isNotEmpty
                ?
             ListView.separated(
        itemCount: filterhotelList.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final hotel = filterhotelList[index];

          return Container(
              width: MediaQuery.of(context).size.width ,

              child: Container(

                 padding: EdgeInsets.only(left: 10,top: 10),

                margin: EdgeInsets.only(left: 20,right: 20,top: 10),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Align(alignment: Alignment.topLeft,child:Container(

                      width: MediaQuery.of(context).size.width * 0.72,
                      child: Align(alignment: Alignment.topLeft,child:Text.rich( // Use Text.rich for convenience
                        TextSpan(
                          text: 'Hotel: ',
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                          children: <InlineSpan>[
                            TextSpan(
                              text: "${hotel.HotelName}",
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),

                            ),



                          ],
                        ),
                      )),

                    )),
                    Align(alignment: Alignment.topLeft,child:Container(

                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Align(alignment: Alignment.topLeft,child:Text.rich( // Use Text.rich for convenience
                        TextSpan(
                          text: 'City: ',
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                          children: <InlineSpan>[
                            TextSpan(
                              text: "${hotel.Place}",
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),

                            ),



                          ],
                        ),
                      )),

                    )),
                    Align(alignment: Alignment.topLeft,child:Container(

                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Align(alignment: Alignment.topLeft,child:Text.rich( // Use Text.rich for convenience
                        TextSpan(
                          text: 'Chain: ',
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                          children: <InlineSpan>[
                            TextSpan(
                              text: "${hotel.ChainName}",
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),

                            ),



                          ],
                        ),
                      )),

                    )),








                    Align(
                      alignment: Alignment.topRight,
                      child: Transform.scale(
                        scale: 0.9, // Adjust this value to make it smaller or larger
                        child: Switch(
                          value: hotel.isselect
                          ,
                          activeColor: Colors.white,
                          inactiveThumbColor: Colors.white,
                          activeTrackColor: Colors.green,
                          onChanged:(value) {

                          },
                        ),
                      ),
                    )




                  ],
                )));



        },
      )
                : Container(),
          ))


    ],);







  }*/



  // Map view Filter

  Future<void> _prepareMarkers() async {
    Set<Marker> tempMarkers = {};

    for (var item in filterhotePlacelList) {
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
      height: MediaQuery.of(context).size.height * 0.95,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(height: 5, width: 40, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
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






  // Helper function to zoom out/in to show all markers



  Widget hotelMapListWidget() {
    return Column(children: [

      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: _dateField(
                label: "From Date",
                selectedDate: _fromDate,
                onTap: () => _selectDate(context, true),
              ),
            ),
            const SizedBox(width: 10),

            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: _filterByHotelDate,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
              child: const Text("Search"),
            ),
          ],
        ),
      ),

      Padding(
          padding: const EdgeInsets.only(left: 0, top: 20),
          child: SizedBox(
            height:
            MediaQuery.of(context).size.height * 0.77,
            child: filterhotePlacelList!.isNotEmpty
                ? ListView.builder(
              scrollDirection: Axis.vertical, // Set horizontal scrolling
              itemCount: filterhotePlacelList!.length,
              itemBuilder: (context, index) {
                var newsModel = filterhotePlacelList![index];
                var ToDate = '-';
                var FromDate = '-';
                List<String> parts = newsModel.dateRange.split('to');
                if (parts.length >= 2) {
                  FromDate= parts[0].trim();
                  ToDate = parts[1].trim();

                }



                return GestureDetector(
                    onTap: () {

                    },
                    child: Container(
                        width: MediaQuery.of(context).size.height * 0.80,

                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.transparent),
                          ),
                          child: Column(
                            children: [


                              _summaryRow('Booking ID', '${newsModel.bookingID}'),
                              _summaryRow('Full Name', "${newsModel.members[0].name} ${newsModel.members[0].FamilyName}"),
                              _summaryRow('Phone', "${newsModel.members[0].Phone}"),
                              _summaryRow('City', "${newsModel.members[0].HotelCityName}."),
                              _summaryRow('Division', "${newsModel.members[0].ChainName}"),

                              _summaryRow('Hotel Name', '${newsModel.members[0].hotel}'),

                              _summaryRow('Date', '   ${formatDate(newsModel.members[0].HotelFromDate)} to ${formatDate(newsModel.members[0].HotelToDate)}', isBoldValue: true),
                           Divider()

                            ],
                          ),
                        )));
              },
            )
                : Container(),
          ))


    ],);





  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });
    }
  }
  Widget _dateField({required String label, DateTime? selectedDate, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(4)),
        child: Text(
          selectedDate == null ? label : DateFormat('dd/MM/yyyy').format(selectedDate),
          style: TextStyle(color: selectedDate == null ? Colors.grey : Colors.black),
        ),
      ),
    );
  }
}


  Widget _summaryRow(String label, String value, {bool isLink = false, bool isBoldValue = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align to top if text wraps
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Label gets a fixed width or limited space if needed
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),

          const SizedBox(width: 16), // Add a gap between label and value

          // Wrap the value in Expanded to force it to respect constraints
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end, // Keeps value on the right
              maxLines: 2,
              overflow: TextOverflow.ellipsis, // Shows "..." if it exceeds 2 lines
              style: TextStyle(
                fontSize: 15,
                fontWeight: (isBoldValue || isLink) ? FontWeight.bold : FontWeight.w500,
                color: isLink ? Colors.blue : Colors.black,
                decoration: isLink ? TextDecoration.underline : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';

    try {
      // 1. Parse the string (handles "2026-12-09 00:00:00" or ISO formats)
      DateTime dateTime = DateTime.parse(dateStr);

      // 2. Format it - this removes the time part entirely
      return DateFormat('dd/MM/yyyy').format(dateTime);
    } catch (e) {
      // If it's a custom format from your API (e.g. 12/09/2026 00:00:00)
      // use a specific pattern to parse it first
      try {
        DateTime customDate = DateFormat("MM/dd/yyyy HH:mm:ss").parse(dateStr);
        return DateFormat('dd/MM/yyyy').format(customDate);
      } catch (innerError) {
        return dateStr; // Return original if everything fails
      }
    }





  }
