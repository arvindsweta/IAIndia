import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:myfirstdemo/Utilities/Util.dart';
import '../../../Model/LoginResponce.dart';
import '../../../Model/TripExpenseResponse.dart';
import '../../../Services/ApiServices/GlobalLoader.dart';
import '../../../Services/ApiServices/SecureStorageService.dart';
import 'ExpenceChatScreen.dart';
import 'ExpenceController.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MyExpenceListPage extends StatefulWidget {
  MyExpenceListPage({super.key});
  @override
  State<MyExpenceListPage> createState() => _MyExpenceListPageState();
}

class _MyExpenceListPageState extends State<MyExpenceListPage> {
  late final ExpenceController expController = Get.put(ExpenceController());
  final SecureStorageService _storageService = SecureStorageService();

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
      TripExpenseResponse? expenceModel = await expController.GetMyExpenceListApi(userId.toString()

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
            const SnackBar(content: Text("Invalid otp")),
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
  deleteExpenceApi(expenceId,int index) async {
    showLoader(context);
    try {
      String? userId = await _storageService.getUserId();
      // Assuming this returns an instance of VerifyOtpResponse
      LoginResponce? expenceModel = await expController.deleteMyExpenceApi(userId.toString(),expenceId.toString()

      );

      if (mounted) {
        dismissLoader(context);
        // Small delay to ensure loader is gone before UI updates or navigation
        await Future.delayed(Duration(milliseconds: 100));

        if (expenceModel != null ) {

          expTripList.removeAt(index);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Expense Delete Successfully"),
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
          setState(() {

          });

        }
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Invalid otp")),
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
          "My Expenses",
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
                              _summaryRow('ExpenceName','${expModel.ExpenceName}'),
                              _summaryRow('Date','${getConvertDate(expModel.ExpenceDate.toString())}'),
                              _summaryRow('Trip Place','${expModel.TriPlace}'),
                              statusRow('Amount', '${expModel.expenseAmount.toString()}'),
                              remarkShow('${expModel.remarks} ${expModel.RembursmentRemarks} ${expModel.ApprovedRemarks}'),
                              statusRow('Status', '${expModel.Status.toString()}'),
                              GestureDetector(
                                onTap: () {
                                  getFullImageBottomSheet(context: context, imageUrl: expModel.expenseImage1.toString(),imageUrl2:expModel.expenseImage2.toString() ,imageUrl3:expModel.expenseImage3.toString() );
                                },
                                child: imageViewRow('${expModel.expenseImage1}', 'Recipt Image'),
                              ),

                              Row(children: [
                                Container(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width*.40,
                                  color: Colors.transparent,
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: ElevatedButton(
                                        onPressed: () {

                                          deleteExpenceApi(expModel.id.toString(),index);

                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.redAccent,
                                          fixedSize: const Size(120, 45),
                                          // Adding the corner radius here
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: const Text('Delete', style: TextStyle(color: Colors.white)),
                                      )
                                  ),


                                ),



                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ExpenceChatScreen(
                                          tripId: expModel.id.toString(),
                                        ),
                                      ),
                                    );
                                  },
                                  // The 'icon' property takes the widget to display (e.g., Icon or SvgPicture)
                                  icon: const Icon(Icons.mark_unread_chat_alt_rounded, color: Colors.white, size: 18),
                                  // The 'label' property replaces the 'child' property
                                  label: const Text('Chat', style: TextStyle(color: Colors.white)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    fixedSize: const Size(120, 45),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ],)



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
  Widget _summaryRow(String label, String value, {bool isLink = false, bool isBoldValue = false}) {
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
              fontWeight: (isBoldValue || isLink) ? FontWeight.bold : FontWeight.w500,
              color: isLink ? Colors.blue : Colors.black,
              decoration: isLink ? TextDecoration.underline : null,
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


  void getFullImageBottomSheet({
    required BuildContext context,
    required String imageUrl,
    required String imageUrl2,
    required String imageUrl3,
  }) {
    final List<String> imgList = [imageUrl, imageUrl2, imageUrl3];

    showCupertinoModalBottomSheet(
      topRadius: const Radius.circular(24),
      context: context,
      duration: const Duration(milliseconds: 700),
      backgroundColor: Colors.white,
      isDismissible: true,
      builder: (BuildContext context) {
        return Material(
          type: MaterialType.transparency,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.94,
            width: MediaQuery.of(context).size.width,
            child: CarouselSlider(
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.94,
                viewportFraction: 1.0, // Full width images
                enableInfiniteScroll: true,
              ),
              items: imgList.map((item) => Builder(
                builder: (BuildContext context) {
                  return CachedNetworkImage(
                    imageUrl: item,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  );
                },
              )).toList(),
            ),
          ),
        );
      },
    );
  }

}