import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../Model/LoginResponce.dart';

import '../../../Model/TripExpenseResponse.dart';
import '../../../Services/ApiServices/GlobalLoader.dart';
import '../../../Services/ApiServices/SecureStorageService.dart';
import '../../../Utilities/Util.dart';

import 'ExpenceController.dart';

class ExpenceAprovedPage extends StatefulWidget {


  ExpenceAprovedPage({super.key});



  @override
  State<ExpenceAprovedPage> createState() => _ExpenceAprovedPageState();
}

class _ExpenceAprovedPageState extends State<ExpenceAprovedPage> {
  late final ExpenceController expController = Get.put(ExpenceController());
  final SecureStorageService _storageService = SecureStorageService();

  final TextEditingController _commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<TripExpenseData> expTripList = [];






  @override
  void initState() {

    getMyExpenceListApi();
    super.initState();

  }

  @override
  void dispose() {

    super.dispose();
  }

  getMyExpenceListApi() async {
    showLoader(context);
    try {
      String? userId = await _storageService.getUserId();
      // Assuming this returns an instance of VerifyOtpResponse
      TripExpenseResponse? expenceModel = await expController.GetAproveExpenceListApi(userId.toString()

      );

      if (mounted) {
        dismissLoader(context);
        // Small delay to ensure loader is gone before UI updates or navigation
        await Future.delayed(Duration(milliseconds: 100));

        if (expenceModel != null ) {
          expTripList = expenceModel.data!.reversed.toList();

          setState(() {

          });

        }
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Invalid Data")),
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

  postAproveRejectExpenceApi(String expenseId,String Status,int index) async {
    showLoader(context);
    try {
      String? userId = await _storageService.getUserId();
      // Assuming this returns an instance of VerifyOtpResponse
      LoginResponce? expenceModel = await expController.PostAproveRejectExpenceApi(

          status: Status,
          userId: userId.toString(),
          remark: _commentController.text.toString(),
          ExpenceID: expenseId,


      );

      if (mounted) {
        dismissLoader(context);
        // Small delay to ensure loader is gone before UI updates or navigation
        await Future.delayed(Duration(milliseconds: 100));

        if (expenceModel != null ) {


          if(Status == "Rejected")
          {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Expense Rejected Successfully"),
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
                content: const Text("Expense Approved Successfully"),
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
          expTripList.removeAt(index);
          setState(() {

          });

          print("Expence List Length: ${expTripList.length}");

          setState(() {

          });


        }
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Invalid Data")),
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
          "Expense To Approve",
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
    return Column(children: [


      Padding(
          padding: const EdgeInsets.only(left: 0, top: 0),
          child: SizedBox(
              height:
              MediaQuery.of(context).size.height * 0.85,
              child: ListView.builder(
                scrollDirection: Axis.vertical, // Set horizontal scrolling
                itemCount: expTripList.length,
                itemBuilder: (context, index) {
                  var expModel = expTripList[index];
                  return GestureDetector(
                      onTap: () {
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.height * 0.47,

                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.black12),
                            ),
                            child: Column(
                              children: [
                                _summaryRow('TripId', '#${expModel.tripId}', isLink: true),
                                _summaryRow('Name','${expModel.NameOfPersone}'),
                                _summaryRow('ExpenceName','${expModel.ExpenceName}'),
                                _summaryRow('Date','${getConvertDate(expModel.ExpenceDate.toString())}'),
                                _summaryRow('Trip Place','${expModel.TriPlace}'),
                                _summaryRow('Amount', '${expModel.expenseAmount.toString()}'),

                                remarkShow('${expModel.remarks} ${expModel.RembursmentRemarks} ${expModel.ApprovedRemarks}'),

                                statusRow('Status', '${expModel.Status.toString()}'),
                                GestureDetector(
                                  onTap: () {
                                    getFullImageBottomSheet(context: context, imageUrl: expModel.expenseImage1.toString());
                                  },
                                  child: imageViewRow('${expModel.expenseImage1}', 'Recipt Image'),
                                ),



                                const Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {

                                        postAproveRejectExpenceApi(expModel.id.toString(), "Approved",index);

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

                                        _displayTextInputDialog(context,expModel.id.toString(), "Rejected",index);

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

          ))

    ]
    );
  }
  //4techbugssmo@gmail.com
  Widget _summaryRow(String label, String value, {bool isLink = false, bool isBoldValue = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          Text(
            value,
            maxLines: 4,
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


  void _displayTextInputDialog(BuildContext context,String tripId,String Status,int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter your description'),
          content: TextField(
            controller: _commentController,
            decoration: const InputDecoration(hintText: "Type something here"),
          ),
          actions: <Widget>[
            // Cancel Button
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                _commentController.clear();
                Navigator.pop(context);
              },
            ),
            // OK Button
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                if(_commentController.text.isNotEmpty)
                {
                  postAproveRejectExpenceApi(tripId.toString(), "Rejected",index);
                  Navigator.pop(context);

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


  Widget statusRow(String label, String value, ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight:  FontWeight.bold ,
              color: value.toString().toUpperCase() == "OPEN"?Colors.orange:value.toString().toUpperCase() == "REJECTED"?
              Colors.redAccent:value.toString().toUpperCase() == "APPROVED"?Colors.green:Colors.black,

            ),
          ),
        ],
      ),
    );
  }
  Widget imageViewRow(String imageUrl, String value, ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          Container(
            width: 100,
            height: 100,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),




        ],
      ),
    );
  }
  getFullImageBottomSheet(
      {required BuildContext context , imageUrl}) {

    showCupertinoModalBottomSheet(
      topRadius: Radius.circular(24),

      context: context,
      duration: Duration(milliseconds: 700),
      backgroundColor: Colors.white,

      isDismissible: true, // Allow for full-height expansion

      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context,
            StateSetter setState /*You can rename this!*/) {
          return Material(
              type: MaterialType.transparency,
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * .94,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0.0),
                      topRight: Radius.circular(0.0),
                    ),

                  ),

                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),


                ),
              ));
        });
      },
    );
  }

}