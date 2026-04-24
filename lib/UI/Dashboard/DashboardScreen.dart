import 'dart:async';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:myfirstdemo/Constants/NotificationCenter.dart';
import 'package:myfirstdemo/Model/TripWrapper.dart';
import 'package:myfirstdemo/Services/ApiServices/GlobalLoader.dart';
import 'package:myfirstdemo/Services/ApiServices/SecureStorageService.dart';
import 'package:myfirstdemo/UI/Dashboard/MyTripView.dart';

import 'package:myfirstdemo/UI/Dashboard/NewTripRequestScreen.dart';
import 'package:myfirstdemo/UI/Dashboard/TripAProvedListView.dart';
import 'package:myfirstdemo/UI/Dashboard/TripDetailView.dart';

import 'package:myfirstdemo/UI/LoginScreen/SignInView.dart';
import '../../Constants/Assets.dart';
import '../../Model/LoginResponce.dart';
import '../../Utilities/Util.dart';
import '../../Widgets/AppBar.dart';
import '../../Widgets/CustomWidgets.dart';
import '../LoginScreen/LoginController.dart';
import 'DashboardController.dart';
import 'Expence/ExpenceAprovedPage.dart';
import 'Expence/MyExpenceListPage.dart';
import 'MyTripRequestListView.dart';
class DashboardScreen extends StatefulWidget {

   var allTripList;
   DashboardScreen({super.key});



  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  late final DashboardController dashboardController = Get.put(DashboardController());
  final SecureStorageService _storageService = SecureStorageService();
  late final LoginController postUserController = Get.put(LoginController());
  List<TripData> filterTripList = [];
  List<TripData> allTripList = [];
  String? totalTripApproved = "";
  String? totalTripRequest = "";
  String? totalCompleteTrip = "";
  late StreamSubscription _sub;
  List<TripData> myTripList = [];
  List<TripData> myTripRequestList = [];
  List<TripData> myTripToAprovedList = [];

   Color bgPurple = Color(0xFFF3F2F8);
  Color primaryBlue = Color(0xFF2B53D3);
 Color cardLightBlue = Color(0xFF4A80F0);
 Color cardDeepBlue = Color(0xFF325BB5);
   Color cardSkyBlue = Color(0xFF0D99FF);
   String? username = "";
  String? selectTabText = "My Trip Request";



  @override
  void initState()  {



    _sub = NotificationCenter.stream.listen((event) {
      if (event == AppEvent.reloadHome) {
        reloadHome();
      }

    });
    postTripApi();
    super.initState();

  }

  @override
  void dispose() {

    super.dispose();
  }

  reloadHome(){
    postTripApi();
  }





  postTripApi() async {
    showLoader(context);
    try {
      TripWrapper? dataModel = await dashboardController.postTripData();

      if (mounted) {
        dismissLoader(context);
        await Future.delayed(const Duration(milliseconds: 100));

        if (dataModel != null) {
          // If the server returns trips, it's a success
          if (dataModel.trips.isNotEmpty) {
            String? userId = await _storageService.getUserId();
            username = await _storageService.getUsername();

            print( "===========>"+ userId.toString());



            allTripList = dataModel.trips!;

            // My Trip Request Filter 1st Tab



            myTripRequestList = allTripList.where((trip) {
              // Requirement 1: TripStatus must be "Completed"
              bool isCompleted = trip.tripStatus != "Completed";

              // Requirement 2: At least one member must report to the current user
              bool matchesManager = trip.members.any((member) => member.MemberID == userId.toString());

              return isCompleted && matchesManager;
            }).toList();

            totalTripRequest = myTripRequestList.length.toString();
            filterTripList = myTripRequestList;

          // My trip 2nd tab

            myTripList = allTripList.where((trip) {
              // Requirement 1: TripStatus must be "Completed"
              bool isCompleted = trip.tripStatus == "Completed";

              // Requirement 2: At least one member must report to the current user
              bool matchesManager = trip.members.any((member) => member.MemberID == userId.toString());

              return isCompleted && matchesManager;
            }).toList();

            totalCompleteTrip = myTripList.length.toString();



            // Trip Approved filter 3rd tab


            myTripToAprovedList = allTripList.where((trip) {
              // Requirement 1: TripStatus must be "Completed"
              bool isCompleted = trip.tripStatus != "Completed" && trip.tripStatus != "Approved" && trip.tripStatus != "Rejected";

              // Requirement 2: At least one member must report to the current user
              bool matchesManager = trip.members.any((member) => member.reportTo == userId.toString());

              return isCompleted && matchesManager;
            }).toList();

            totalTripApproved = myTripToAprovedList.length.toString();

          /// Totla mytrip
           /* myTripList = (allTripList ?? []).where((trip) {
              // Now .reportTo is recognized because it's in the TripMember class
              return trip.members.any((member) =>

              member.reportTo == userId.toString()
              );
            }).toList();

            totalCompleteTrip = myTripList.length.toString();*/






            setState(() {

            });

            print("Loaded ${dataModel.trips.length} trips successfully.");

            setState(() {
              // Assign dataModel.trips to a local list variable here
              // e.g., myTripList = dataModel.trips;
            });

            // Optional: If your API specifically sends "Valid" as a string
            if (dataModel.rawStatus == "Valid") {
              print("Status is Valid");
            }

          } else {
            print("No trips found or status: ${dataModel.rawStatus}");
            // CustomSnackBar().showSnackbar("Info", "No trip data available");
          }
        }
      }
    } catch (e) {
      print("Error in postTripApi: $e");
      if (mounted) dismissLoader(context);
    }
  }

 logout(){
  Future.delayed(Duration(milliseconds: 2), () {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialWithModalsPageRoute(builder: (context) => SignInView()),
            (Route<dynamic> route) => false);
  });
}


  @override
  Widget build(BuildContext context) {



    return PopScope(
        canPop: false, // 2. Set this to false to disable the back button/gesture
        onPopInvokedWithResult: (bool didPop, Object? result) {
          if (didPop) {
            return;
          }
          // 3. Optional: Add your custom logic here (e.g., show a dialog)
          print("Back button was pressed, but we blocked it!");
        },
        child:Scaffold(
      body:Stack(children: [

        Container(
         padding: EdgeInsets.only(top: 100),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
    Color(0xFFFBFBFB),
    Color(0xFFE8F9FF),
                Color(0xFFC4D9FF),
                Color(0xFFA8F1FF),
                Color(0xFF6FE6FC),

              ],
            ),
          ),


          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  color: Colors.transparent,
                  child: SizedBox(
              width: 100,
              height: 100,


                    child: imageView(

                      assetName: Assets.iailogo,
                      fit: BoxFit.fill, // better for circular images


          )),

                ),


                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.4,
                  children: [
                    GestureDetector(onTap:(){


                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyTripRequestListView(

                            )),
                      );



                      filterTripList = myTripRequestList;
                      setState(() {
                      });
                    },child: _buildMenuCard("My Trip Requests", Icons.work_history_outlined, cardLightBlue,totalTripRequest.toString())),



                    GestureDetector(onTap:(){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyTripView(

                            )),
                      );
                    },child:_buildMenuCard("My Trips", Icons.public, cardDeepBlue,totalCompleteTrip.toString())),




                    GestureDetector(onTap:(){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TripAProvedListView(allTripList: myTripToAprovedList,

                            )),
                      );

                    },child:_buildMenuCard("Trips to Approve", Icons.assignment_turned_in_outlined, Colors.orange.withOpacity(0.7),totalTripApproved.toString())),
                    GestureDetector(onTap:(){

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewTripRequestScreen(

                            )),
                      );

                    },child:_buildMenuCard("Create New Trip", Icons.add_location_alt_outlined, cardSkyBlue,"")),
                    GestureDetector(onTap:(){

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyExpenceListPage(

                            )),
                      );

                    },child:_buildMenuCard("My Expenses", Icons.money, Colors.lightGreen,"")),
                    GestureDetector(onTap:(){

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExpenceAprovedPage(

                            )),
                      );

                    },child:_buildMenuCard("Expense To Approve", Icons.tap_and_play_rounded, Colors.orange,"")),
                  ],
                ),
                SizedBox(height: 20,),






                //_buildNotificationList(),
                // Recent Activity List




              ],
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 100,
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Padding(padding: EdgeInsets.only(left: 10,top: 50),child:  Align(alignment:Alignment.topLeft,child:

    RichText(
    text: TextSpan(
    text: "${getGreeting()}:",
    style: TextStyle(color: Colors.grey, fontSize: 14,fontWeight: FontWeight.bold,), // Default style
    children: <TextSpan>[
      TextSpan(text: ' '),
    TextSpan(
    text: username.toString().toUpperCase(),
    style: TextStyle(
      fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    ),
    ),

    ],
    ),
    ))),



              Container(child:Row(children: [

                InkWell(
                  onTap: (){
                    postTripApi();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 15,
                      right: 16.0,
                      left: 10,
                    ),
                    child: SizedBox(
                        height: 30,
                        width: 30,
                        child: svgView(
                            assetName: Assets.refreshIcon,
                            fit: BoxFit.contain)),
                  ),
                ),
                InkWell(
                  onTap: () {
                    showLogoutDialog(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 15,
                      right: 16.0,
                      left: 10,
                    ),
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: svgView(
                        assetName: Assets.logoutIcon,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],),)
            ],),
        ),

      ],),

      // Bottom Navigation Bar

    ));
  }
  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Do you want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // ❌ Close dialog
              },
              child: Text("No"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                logout(); // ✅ Call your logout function
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }
  // Helper widget for Grid Cards
  Widget _buildMenuCard(String title, IconData icon, Color color,String totalCount) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              totalCount,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),

        ],
      ),
    );
  }



}