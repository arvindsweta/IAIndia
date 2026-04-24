import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myfirstdemo/Model/LoginResponce.dart';
import 'package:myfirstdemo/Services/ApiServices/GlobalLoader.dart';
import 'package:myfirstdemo/Services/ApiServices/SecureStorageService.dart';
import 'package:myfirstdemo/Utilities/Util.dart';

import '../../../Helper/ImagePickerService.dart';
import '../../../Model/ExpenceListModel.dart';
import '../../../Model/MyTripListModel.dart';

import '../DashboardController.dart';
import 'ExpenceController.dart';
class AddExpenseView extends StatefulWidget {

  var  tripId;
  var  tripDate;
  AddExpenseView({super.key,required this.tripId,required this.tripDate});



  @override
  State<AddExpenseView> createState() => _AddExpenseViewState();
}

class _AddExpenseViewState extends State<AddExpenseView> {

  late final ExpenceController dashboardController = Get.put(ExpenceController());
  final SecureStorageService _storageService = SecureStorageService();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<TripListData> filterTripList = [];
  List<TripListData> myTripList = [];
  var ToDate = '-';
  var FromDate = '-';
  File? _pickedImage1;
  File? _pickedImage2;
  File? _pickedImage3;
  String formattedString1 = "";
  String formattedString2 = "";
  String formattedString3 = "";
 List<ExpenceItem> expenceList = [];

  ExpenceItem? _selectedCategory;
  String selectDate = "";
  String checkInTime = "Check In Time";
  String checkOutTime = "Check Out Time";

  List<String> base64List = [];

  int imagesIndex = 0;

  String checkinDate = "";
  String checkOutDate = "";


  @override
  void initState() {


    print(widget.tripDate.toString());

    List<String> parts = widget.tripDate.split('to');
    if (parts.length >= 2) {
      /*FromDate= parts[0].trim();
      ToDate = parts[1].trim();*/

      String inputDate = parts[0].trim();
      String lastDate = parts[1].trim();

      // 1. Define the input format (y matches 2-digit years)
      DateFormat inputFormat = DateFormat("dd-MMM-yy");

      // 2. Parse the string into a DateTime object
      DateTime dateTime = inputFormat.parse(inputDate);
      DateTime lastTime = inputFormat.parse(lastDate);

      // 3. Define the output format
      DateFormat outputFormat = DateFormat("dd-MM-yyyy");
      DateFormat outputFormat1 = DateFormat("yyyy-MM-dd");

      // 4. Format the DateTime object into the new string
      FromDate = outputFormat.format(dateTime);

      checkinDate = outputFormat1.format(dateTime);

      ToDate = outputFormat.format(lastTime);
      checkOutDate = outputFormat1.format(lastTime);

     setState(() {

     });



    }

    getExpenceListApi();
    super.initState();

  }

  @override
  void dispose() {

    super.dispose();
  }


  void _submitData() {
    if (_formKey.currentState!.validate()) {

      PostAddExpenceApi();


    }
  }


  getExpenceListApi() async {
    showLoader(context);
    try {
      String? userId = await _storageService.getUserId();
      // Assuming this returns an instance of VerifyOtpResponse
      ExpenceListModel? expenceModel = await dashboardController.GetExpenceListApi(

      );

      if (mounted) {
        dismissLoader(context);
        // Small delay to ensure loader is gone before UI updates or navigation
        await Future.delayed(Duration(milliseconds: 100));

        if (expenceModel != null ) {

          expenceList = expenceModel.d!;





          setState(() {

          });


        }
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Invalid")),
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
  Future<void> PostAddExpenceApi() async {
    showLoader(context);
    String? userId = await _storageService.getUserId();

    try {
      List<String> parts = FromDate.split("-");
      String formattedDate = "${parts[2]}-${parts[1]}-${parts[0]}";

      // 1. Create the Expense first
      LoginResponce? dataModel = await dashboardController.PostAddExpenceApi(
        tripId: widget.tripId.toString(),
        cotegoriId: _selectedCategory!.iD.toString(),
        category: _selectedCategory!.ExpenceName.toString(),
        remark: _commentController.text,
        ExpenceID: _selectedCategory!.iD.toString(),
        amount: _amountController.text,
        userId: userId.toString(),
        expenceDate:getFormattedDateYMD(formattedDate) ,
        Picktime: checkInTime,
        Droptime: checkOutTime,
        expenceToDate: getFormattedDateYMD(checkOutDate)
      );

      if (dataModel != null && mounted) {
        Map<String, dynamic> innerData = jsonDecode(dataModel.d.toString());
        int expenceId = innerData['ID'];

        // 2. Loop through all images to upload them
        bool allUploaded = true;
        for (int i = 0; i < base64List.length; i++) {
          bool success = await PostUploadImageExpenceApi(expenceId, i + 1, base64List[i]);
          if (!success) {
            allUploaded = false;
            break; // Stop if one fails
          }
        }

        // 3. Cleanup and Navigation
        if (mounted) {
          dismissLoader(context);
          if (allUploaded) {

            Navigator.pop(context);
          }
        }
      } else {
        if (mounted) dismissLoader(context);
      }
    } catch (e) {
      print("Error: $e");
      if (mounted) dismissLoader(context);
    }
  }
  Future<void> PostCalculateExpenceApi() async {
    showLoader(context);
    String? userId = await _storageService.getUserId();

    try {


      // 1. Create the Expense first
      LoginResponce? dataModel = await dashboardController.PostCalculateApi(
        tripId: widget.tripId.toString(),
        fromDate:checkinDate,
        Todate: checkOutDate,
        Picktime: checkInTime,
        Droptime: checkOutTime,

      );

      if (mounted) {

       dismissLoader(context);
        // Small delay to ensure loader is gone before UI updates or navigation
        await Future.delayed(Duration(milliseconds: 100));

        if (dataModel != null) {

          print('The value is: ${dataModel.d}');
          if (dataModel.d == "Invalid") {


          } else {

            var value = dataModel.d.toString();

           print("price "+ value.toString());
            _amountController.text = value.toString();


            setState(() {

            });
          }
        }
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Invalid")),
          );
        }

      }

    } catch (e) {
      print("Error: $e");
      if (mounted) dismissLoader(context);
    }
  }

// Returns a boolean so the parent function knows if it succeeded
  Future<bool> PostUploadImageExpenceApi(int expenceId, int index, String base64Image) async {
    try {
      LoginResponce? dataModel = await dashboardController.postUploadImageByExpenceIdApi(
        expenceID: expenceId.toString(),
        base64Image: base64Image,
        OrderNo: index.toString(),
        fileName: "${expenceId}_${DateTime.now().millisecondsSinceEpoch}_expence_$index.png",
      );

      return dataModel != null; // Return true if success
    } catch (e) {
      print("Error uploading image $index: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Expense")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Category Dropdown
              DropdownButtonFormField<ExpenceItem>( // 1. Change type from String to CityItem
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: "Select Category",
                  border: OutlineInputBorder(),

                ),
                // 2. Ensure value: option is passed as the CityItem object
                items: expenceList.map((ExpenceItem option) {
                  return DropdownMenuItem<ExpenceItem>(
                    value: option,
                    child: Text(option.ExpenceName ?? "Unknown"), // Handle null safety
                  );
                }).toList(),
                // 3. Remove '.n' and ensure _selectedHotel is of type CityItem?
                onChanged: (ExpenceItem? val) {
                  setState(() {
                    _selectedCategory = val;
                  });
                },
                validator: (val) => val == null ? "Select a category" : null,
              ),
              const SizedBox(height: 20),



              // 2. Amount Field



              GestureDetector(
                  onTap: () => _selectDate(context,"FROM"), // PASSING SETTER HERE
                  child: _buildDateInputField(checkinDate)),
              const SizedBox(height: 15),

              Visibility(visible: _selectedCategory?.iD == 6?true:false,child:Container(
                child: Column(children: [

                  GestureDetector(
                      onTap: () => _selectExpenceDate(context,"toDate"), // PASSING SETTER HERE
                      child: _buildDateInputField(checkOutDate)),
                  const SizedBox(height: 15),

                  GestureDetector(
                      onTap: () => _selectTime(context,"FROM"), // PASSING SETTER HERE
                      child: _buildTimeInputField(checkInTime)),
                  const SizedBox(height: 15),
                  GestureDetector(
                      onTap: () => _selectTime(context,"toDate"), // PASSING SETTER HERE
                      child: _buildTimeInputField(checkOutTime)),
                  const SizedBox(height: 15),
                ],),
              )),

              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: "Amount",
                  hintText: "0.00",
                  prefixText: "", // Change to your currency symbol
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.money),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return "Enter an amount";
                  if (double.tryParse(val) == null) return "Enter a valid number";
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // 3. Comment Field
              TextFormField(
                controller: _commentController,
                maxLines: 3, // Multi-line for longer comments
                decoration: const InputDecoration(
                  labelText: "Comments / Notes",
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 40), // Adjust icon alignment
                    child: Icon(Icons.notes),
                  ),
                ),
              ),
              const SizedBox(height: 30),


              Container(

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,

                  children:

                  [

                        GestureDetector(onTap:(){
                          pickImage(context,"1");
                        },
                            child:Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Stack(
                            children: [
                              // Content: Image or Icon
                              Center(
                                child: _pickedImage1 == null
                                    ?  Icon(Icons.add_a_photo, size: 50, color: Colors.grey)
                                    : ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child:  Image.file(
                                    _pickedImage1!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),

                              // Close Button: Only show if an image is present
                              if (_pickedImage1 != null)
                                Positioned(
                                  right: 5,
                                  top: 5,
                                  child: GestureDetector(
                                    onTap: (){
                                      _pickedImage1 = null;
                                      formattedString1 = "";
                                      setState(() {

                                    });
                                    },
                                    child: const CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.red,
                                      child: Icon(Icons.close, size: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )),
                    SizedBox(width: 20,),


                    GestureDetector(onTap:(){
                      pickImage(context,"2");
                    },
                        child:Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Stack(
                            children: [
                              // Content: Image or Icon
                              Center(
                                child: _pickedImage2 == null
                                    ?  Icon(Icons.add_a_photo, size: 50, color: Colors.grey)
                                    : ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child:  Image.file(
                                    _pickedImage2!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),

                              // Close Button: Only show if an image is present
                              if (_pickedImage2 != null)
                                Positioned(
                                  right: 5,
                                  top: 5,
                                  child: GestureDetector(
                                    onTap: (){
                                      _pickedImage2 = null;
                                      formattedString2 = "";
                                      setState(() {

                                      });
                                    },
                                    child: const CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.red,
                                      child: Icon(Icons.close, size: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )),
                  /*  GestureDetector(onTap:(){
                      pickImage(context,"3");
                    },
                        child:Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Stack(
                            children: [
                              // Content: Image or Icon
                              Center(
                                child: _pickedImage3 == null
                                    ?  Icon(Icons.add_a_photo, size: 50, color: Colors.grey)
                                    : ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child:  Image.file(
                                    _pickedImage3!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),

                              // Close Button: Only show if an image is present
                              if (_pickedImage3 != null)
                                Positioned(
                                  right: 5,
                                  top: 5,
                                  child: GestureDetector(
                                    onTap: (){
                                      _pickedImage3 = null;
                                      formattedString3 = "";
                                      setState(() {

                                    });
                                    },
                                    child: const CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.red,
                                      child: Icon(Icons.close, size: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )),*/


                  ],),




              ),

              const SizedBox(height: 15),


              // 4. Submit Button
              ElevatedButton(
                onPressed: _submitData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  fixedSize: const Size(300,40),
                  // Adding the corner radius here
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("SUBMIT EXPENSE", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickImage(BuildContext context ,String imageNo) async {
    final pickedFile = await ImagePickerService().showImageSourceDialog(context);

    if (pickedFile != null) {
      setState(() async {

        File file = File(pickedFile.path);
        if(imageNo == "1") {
          _pickedImage1 = File(pickedFile.path);



          List<int> imageBytes = await file.readAsBytes();
          String base64String = base64Encode(imageBytes);
          formattedString1 = base64String;
          base64List.add(formattedString1);

        }
       else if(imageNo == "2") {
          _pickedImage2 = File(pickedFile.path);



          List<int> imageBytes = await file.readAsBytes();
          String base64String = base64Encode(imageBytes);
          formattedString2 = base64String;
          base64List.add(formattedString2);
        }
        else if(imageNo == "3") {
          _pickedImage3 = File(pickedFile.path);



          List<int> imageBytes = await file.readAsBytes();
          String base64String = base64Encode(imageBytes);
          formattedString3 = base64String;
          base64List.add(formattedString3);
        }
        setState(() {

        });


      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No image selected.')),
      );
    }
  }

  Future<void> _selectTime(BuildContext context, String toselect) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      // This forces the text input field instead of the dial
      initialEntryMode: TimePickerEntryMode.input,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          // This ensures the text field expects 24-hour logic
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final String formatted24H =
          "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";


      setState(() {
        if (toselect == "FROM") {
          checkInTime = formatted24H;
        } else {
          checkOutTime = formatted24H;
          PostCalculateExpenceApi();
        }
      });
    }
  }

  Widget _buildDateInputField(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(hint, style: const TextStyle(fontSize: 16, color: Colors.black54)),
          const Icon(Icons.calendar_today_outlined, color: Colors.black, size: 20),
        ],
      ),
    );
  }
  Widget _buildTimeInputField(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(hint, style: const TextStyle(fontSize: 18, color: Colors.black54)),
          const Icon(Icons.access_time, color: Colors.black54),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, String toselect) async {
    // Hide keyboard before opening picker
    FocusScope.of(context).unfocus();

    DateTime initialDate;
    DateTime lastsDate;

    try {
      // Parsing FromDate (Format: DD-MM-YYYY)
      List<String> parts = FromDate.split('-');
      int day = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int year = int.parse(parts[2]);
      initialDate = DateTime(year, month, day);
    } catch (e) {
      debugPrint("FromDate parsing error: $e");
      initialDate = DateTime.now();
    }

    try {
      // Parsing ToDate (Format: DD-MM-YYYY)
      List<String> toParts = ToDate.split('-');
      int d = int.parse(toParts[0]);
      int m = int.parse(toParts[1]);
      int y = int.parse(toParts[2]);
      lastsDate = DateTime(y, m, d);
    } catch (e) {
      debugPrint("ToDate parsing error: $e");
      lastsDate = DateTime.now().add(const Duration(days: 365));
    }

    // Safety Check: initialDate must be between firstDate and lastDate
    // We use DateTime(2000) as a generic floor, but you can adjust this.
    DateTime firstAllowedDate = DateTime(2000);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstAllowedDate,
      lastDate: lastsDate,
      helpText: 'SELECT ${toselect.toUpperCase()} DATE',
    );

    if (picked != null) {
      // The Fix: Added .padLeft(2, '0') to the day property
      String formattedDate =
          "${picked.year}-"
          "${picked.month.toString().padLeft(2, '0')}-"
          "${picked.day.toString().padLeft(2, '0')}";

      setState(() {
        checkinDate = formattedDate;
      });
    }
  }
  Future<void> _selectExpenceDate(BuildContext context, String toselect) async {
    FocusScope.of(context).unfocus();

    DateTime initialDate;
    DateTime lastsDate;

    try {
      // Parsing FromDate (Format: DD-MM-YYYY)
      List<String> parts = FromDate.split('-');
      int day = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int year = int.parse(parts[2]);
      initialDate = DateTime(year, month, day);
    } catch (e) {
      debugPrint("FromDate parsing error: $e");
      initialDate = DateTime.now();
    }

    try {
      // Parsing ToDate (Format: DD-MM-YYYY)
      List<String> toParts = ToDate.split('-');
      int d = int.parse(toParts[0]);
      int m = int.parse(toParts[1]);
      int y = int.parse(toParts[2]);
      lastsDate = DateTime(y, m, d);
    } catch (e) {
      debugPrint("ToDate parsing error: $e");
      lastsDate = DateTime.now().add(const Duration(days: 365));
    }

    // Safety Check: initialDate must be between firstDate and lastDate
    // We use DateTime(2000) as a generic floor, but you can adjust this.
    DateTime firstAllowedDate = DateTime(2000);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstAllowedDate,
      lastDate: lastsDate,
      helpText: 'SELECT ${toselect.toUpperCase()} DATE',
    );

    if (picked != null) {
      // The Fix: Added .padLeft(2, '0') to the day property
      String formattedDate =
          "${picked.year}-"
          "${picked.month.toString().padLeft(2, '0')}-"
          "${picked.day.toString().padLeft(2, '0')}";

      setState(() {
        checkOutDate = formattedDate;
      });
    }
  }
}



