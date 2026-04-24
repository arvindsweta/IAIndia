import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myfirstdemo/Constants/NotificationCenter.dart';
import 'package:myfirstdemo/Model/LoginResponce.dart';
import 'package:myfirstdemo/Model/TripWrapper.dart';
import 'package:myfirstdemo/Services/ApiServices/GlobalLoader.dart';
import 'package:myfirstdemo/Services/ApiServices/SecureStorageService.dart';

import 'package:myfirstdemo/UI/Dashboard/NewTripRequestScreen.dart';
import 'DashboardController.dart';
class TripAProvedListView extends StatefulWidget {

  var allTripList;
  TripAProvedListView({super.key,required this.allTripList});



  @override
  State<TripAProvedListView> createState() => _TripAProvedListViewState();
}

class _TripAProvedListViewState extends State<TripAProvedListView> {

  late final DashboardController dashboardController = Get.put(DashboardController());
  final SecureStorageService _storageService = SecureStorageService();
  final TextEditingController remarksController = TextEditingController();

  List<TripData> filterTripList = [];
  List<TripData> allTripList = [];
  String? totalTripApproved = "";
  String? totalTripRequest = "";
  String? totalCompleteTrip = "";

  List<TripData> myTripToAprovedList = [];



  @override
  void initState() {
    myTripToAprovedList =  widget.allTripList.reversed.toList();


    super.initState();

  }

  @override
  void dispose() {

    super.dispose();
  }



  postTripRejectApprovedApi(String tripId,String Status,int index) async {

    String? userId = await _storageService.getUserId();

    showLoader(context);
    try {

      LoginResponce? dataModel = await dashboardController.PostTripAproveRejectRequestApi(tripId: tripId, status: Status, userId: userId.toString(),remark: remarksController.text

      );

      if (mounted) {
        dismissLoader(context);
        // Small delay to ensure loader is gone before UI updates or navigation
        await Future.delayed(Duration(milliseconds: 100));

        if (dataModel != null) {

          Map<String, dynamic> innerData = jsonDecode(dataModel.d.toString());
          String status = innerData['lbl'] ?? "";
          if(status == "Updated")
            {
              if(Status == "Rejected")
                {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Trip Rejected Successfully"),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                      // Push the snackbar to the top
                      margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height - 150, // Adjust based on your needs
                        right: 10,
                        left: 10,
                      ),
                    ),
                  );
                }
              else{
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Trip Approved Successfully"),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    // Push the snackbar to the top
                    margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height - 150, // Adjust based on your needs
                      right: 10,
                      left: 10,
                    ),
                  ),
                );
              }

              NotificationCenter.post(AppEvent.reloadHome);
              myTripToAprovedList.removeAt(index);
              setState(() {

              });




              //Navigator.pop(context);


          }
        }
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Invalid data")),
          );
        }

      }
    } catch (e) {
      print("Error in postVerifyUserApi: $e");
      if (mounted) {
        dismissLoader(context);
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    // Custom Colors based on your mockup
    const Color bgPurple = Color(0xFFF3F2F8);


    return Scaffold(
      backgroundColor: bgPurple,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Trip To Approved",
          style: TextStyle(color: Color(0xFF1A1C4E), fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            latestNewsWidget()










          ],
        ),
      ),

      // Bottom Navigation Bar

    );
  }

  // Helper widget for Grid Cards



  Widget latestNewsWidget() {
    return Padding(
        padding: const EdgeInsets.only(left: 0, top: 10),
        child: SizedBox(
          height:
          MediaQuery.of(context).size.height * 0.85,
          child: myTripToAprovedList!.isNotEmpty
              ? ListView.builder(
            scrollDirection: Axis.vertical, // Set horizontal scrolling
            itemCount: myTripToAprovedList!.length,
            itemBuilder: (context, index) {
              var newsModel = myTripToAprovedList![index];
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
                          border: Border.all(color: Colors.black12),
                        ),
                        child: Column(
                          children: [


                            _summaryRow('Booking ID', '${newsModel.bookingID}', isLink: true),
                            _summaryRow('From Date', FromDate.toString()),
                            _summaryRow('To Date', ToDate.toString()),
                            _summaryRow('From', '${newsModel.members[0].FromCity}'),
                            _summaryRow('To', '${newsModel.members[0].ToCity}'),
                            _summaryRow('Employee Name', '${newsModel.members[0].name} ${newsModel.members[0].FamilyName}'),
                            remarkShow( '${newsModel.members[0].Remarks}'),

                            _summaryRow('Status', '${newsModel.tripStatus}', isBoldValue: true),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  onPressed: () {

                                    postTripRejectApprovedApi(newsModel.id.toString(), "Approved",index);

                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    fixedSize: const Size(120, 45),
                                    // Adding the corner radius here
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text('Approved', style: TextStyle(color: Colors.white)),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {

                                    _displayTextInputDialog(context,newsModel.id.toString(), "Rejected",index);




                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    fixedSize: const Size(120, 45),
                                    // Adding the corner radius here
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text('Reject', style: TextStyle(color: Colors.white)),
                                )
                              ],
                            )

                          ],
                        ),
                      )));
            },
          )
              : Container(),
        ));
  }

  void _displayTextInputDialog(BuildContext context,String tripId,String Status,int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter your description'),
          content: TextField(
            controller: remarksController,
            decoration: const InputDecoration(hintText: "Type something here"),
          ),
          actions: <Widget>[
            // Cancel Button
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                remarksController.clear();
                Navigator.pop(context);
              },
            ),
            // OK Button
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                if(remarksController.text.isNotEmpty)
                  {
                    postTripRejectApprovedApi(tripId.toString(), "Rejected",index);
                    Navigator.pop(context);
                    remarksController.text = "";
                  }



              },
            ),
          ],
        );
      },
    );
  }

  Widget remarkShow(String value){
    return Container(

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Keeps label at the top
        children: [
          const Text(
              "Remark: ",
              style: TextStyle(fontWeight: FontWeight.bold)
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight, // Forces text to the right
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight:  FontWeight.w500,
                  color:  Colors.black,

                ),// Optional: aligns the text block to the right
              ),
            ),
          ),
        ],
      ),
    );
  }
  //4techbugssmo@gmail.com
  Widget _summaryRow(String label, String value, {bool isLink = false, bool isBoldValue = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: (isBoldValue || isLink) ? FontWeight.bold : FontWeight.w500,
              color: isLink ? Colors.blue : Colors.black,
              decoration: isLink ? TextDecoration.underline : null,
            ),
          ),
        ],
      ),
    );
  }
}