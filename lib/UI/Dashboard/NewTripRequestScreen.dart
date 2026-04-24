import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myfirstdemo/Model/CityModel.dart';
import 'package:myfirstdemo/Model/LoginResponce.dart';
import 'package:myfirstdemo/Model/TravelerModel.dart';
import 'package:myfirstdemo/Services/ApiServices/GlobalLoader.dart';
import 'package:myfirstdemo/Services/ApiServices/SecureStorageService.dart';
import 'package:myfirstdemo/UI/Dashboard/DashboardController.dart';
import 'package:myfirstdemo/UI/LoginScreen/LoginController.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../Constants/NotificationCenter.dart';
import '../../Model/HotelListByCityModel.dart';



class NewTripRequestScreen extends StatefulWidget {
  const NewTripRequestScreen({super.key});

  @override
  State<NewTripRequestScreen> createState() => _NewTripRequestScreenState();
}

class _NewTripRequestScreenState extends State<NewTripRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  String fromTime = "";
  String toTime = "";
  //String fromTime = DateFormat.jm().format(DateTime.now());
  late final LoginController postUserController = Get.put(LoginController());
  late final DashboardController dashboardController = Get.put(DashboardController());
  bool isSpecificTime = false;
  final SecureStorageService _storageService = SecureStorageService();
  final TextEditingController commentController = TextEditingController();
  final TextEditingController otherTextController = TextEditingController();
  TravelerModel? userModel;


  bool isSelectHotel = true;
  bool isSelectflight = true;
  bool isSelectTrains = true;
  bool isSelectOther = false;

  bool Before6AM = false;
  bool SixToTwelve = false;
  bool TwelveToSix = false;
  bool After6PM = false;
  bool SpecificTime = false;
  List<HotelCityItem> hotelList = [];



  String tripId = "";
  String tripType = "";
   List<CityItem> locationList = [];
  String _selectedTrip = 'One Way';


  String selectHotel = "Enter Hotel";
  String arrivalLocation = "Enter Arrival";
  String destinationLocation = "Enter Destination";
  String arrivalLocationId = "";
  String destinationLocationId = "";

  String fromDate = "";
  String toDate = "";


  String remark = "";

  HotelCityItem? _selectedHotel;



  // Mock list of cities/locations

  @override
  void initState() {
    postUserDetailsApi();
    postCityApiApi();
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  postUserDetailsApi() async {
    showLoader(context);
    try {
      String? userId = await _storageService.getUserId();

      userModel = await postUserController.GetUserProfile(
        userId: userId.toString(),
      );

      if (mounted) {
        dismissLoader(context);
        // Small delay to ensure loader is gone before UI updates or navigation
        await Future.delayed(Duration(milliseconds: 100));

        if (userModel != null ) {


          print(userModel?.familyName.toString());
          setState(() {

          });
          // Now dataModel.d is a proper Map: {"UserID": "1575-Mahesh Singh-IAI CORP"}

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
  postCityApiApi() async {
    showLoader(context);
    try {
      String? userId = await _storageService.getUserId();
      // Assuming this returns an instance of VerifyOtpResponse
      CityModel? cityModel = await dashboardController.GetCityListApi(
       
      );

      if (mounted) {
        dismissLoader(context);
        // Small delay to ensure loader is gone before UI updates or navigation
        await Future.delayed(Duration(milliseconds: 100));

        if (cityModel != null ) {

         print(cityModel.d?.length.toString());


         locationList = cityModel.d!;
         
          setState(() {

          });
          // Now dataModel.d is a proper Map: {"UserID": "1575-Mahesh Singh-IAI CORP"}

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

  getHotelByCityApiApi() async {
    showLoader(context);
    try {
      String? userId = await _storageService.getUserId();
      // Assuming this returns an instance of VerifyOtpResponse
      HotelListByCityModel? hotelModel = await dashboardController.GetHotelByCityListApi(arrivalLocation.toString(),arrivalLocationId.toString()

      );

      if (mounted) {
        dismissLoader(context);
        // Small delay to ensure loader is gone before UI updates or navigation
        await Future.delayed(Duration(milliseconds: 100));

        if (hotelModel != null ) {



          hotelList = hotelModel.d!;


          setState(() {

          });
          // Now dataModel.d is a proper Map: {"UserID": "1575-Mahesh Singh-IAI CORP"}

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

  postAddTripRequestApi() async {

    int totalDays = getDaysBetween(fromDate, toDate);

    showLoader(context);
    try {

      LoginResponce? dataModel = await dashboardController.PostAddTripRequestApi(
         arrCity: destinationLocation, desCity: arrivalLocation, startDate: fromDate, endDate: toDate, noOfDays: totalDays.toString(),
        remarks: commentController.text.toString(), TripType: tripType.toString(),arrCountry: destinationLocationId,desCountry: arrivalLocationId
      );

      if (mounted) {


        // Small delay to ensure loader is gone before UI updates or navigation
        await Future.delayed(Duration(milliseconds: 100));

        if (dataModel != null) {

          print('The value is: ${dataModel.d}');
          if (dataModel.d == "Invalid") {


          } else {

            tripId = dataModel.d.toString();

            SaveTravellerRequestApi(dataModel.d.toString());


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
      print("Error in postVerifyUserApi: $e");
      if (mounted) {
        dismissLoader(context);
      }
    }
  }

  SaveTravellerRequestApi(String TripId) async {

    String? userId = await _storageService.getUserId();


    try {

      LoginResponce? dataModel = await dashboardController.SaveTravellerRequestApi(
        userModel: userModel, startDate: fromDate, endDate: toDate, remarks: commentController.text.toString(),  TripID: tripId, MemberID: userId.toString(),
      );

      if (mounted) {

        // Small delay to ensure loader is gone before UI updates or navigation
        await Future.delayed(Duration(milliseconds: 100));

        if (dataModel != null) {

          SaveTripDetails();

          print('The value is: ${dataModel.d}');
          if (dataModel.d == "Invalid") {


          } else {





          }
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
  SaveTripDetails() async {


    int totalDays = getDaysBetween(fromDate, toDate);

    try {

      LoginResponce? dataModel = await dashboardController.SaveTripDetails(
        userModel: userModel,
        ArrivalCityID: destinationLocationId,
        DepartureCityID: arrivalLocationId,
        After6PM: After6PM,
        TwelveToSix: TwelveToSix,
        SixToTwelve: SixToTwelve,
        Before6AM: Before6AM,
        SpecificTime: SpecificTime,
        FromTime: fromTime,
        ToTime: toTime,
        FromDate: fromDate,
        ToDate: toDate,
        Airport: isSelectflight,
        Hotel: isSelectHotel,
        Cab: isSelectTrains,
        OtherTravel: isSelectOther,
        OtherText: otherTextController.text.toString(),
        TripID: tripId,
        DepartureName:arrivalLocation,
        ArrivalName: destinationLocation,
        NoOfDays: totalDays.toString(),
        TripType: _selectedTrip.toString(),
        remarks: commentController.text.toString(),
        hotelId: _selectedHotel?.iD.toString() ?? "0"
      );

      if (mounted) {
        dismissLoader(context);
        // Small delay to ensure loader is gone before UI updates or navigation
        await Future.delayed(Duration(milliseconds: 100));

        if (dataModel != null) {

          print('The value is: ${dataModel.d}');
          if (dataModel.d == "Invalid") {


          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Trip Request Submitted Successfully"),
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
            NotificationCenter.post(AppEvent.reloadHome);
            Navigator.pop(context);


            setState(() {

            });
          }
        }
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Invalid ")),
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





  int getDaysBetween(String start, String end) {
    // Define the format matching your input strings
    DateFormat format = DateFormat("dd-MM-yyyy");

    try {
      // 1. Parse using the specific format
      DateTime startDate = format.parse(start);
      DateTime endDate = format.parse(end);

      // 2. Calculate the difference
      Duration diff = endDate.difference(startDate);

      // 3. Return the days
      return diff.inDays;
    } catch (e) {
      print("Error parsing dates: $e");
      return 0; // Or handle the error as needed for your UI
    }
  }

  // Replace your Submit button's onPressed and add this validation method

  bool _validateForm() {
    // 1. Destination check
    if (destinationLocation.isEmpty || destinationLocation == "Enter Destination") {
      _showError("Please select a 'From' (Departure) city.");
      return false;
    }

    // 2. Arrival check
    if (arrivalLocation.isEmpty || arrivalLocation == "Enter Arrival") {
      _showError("Please select a 'To' (Arrival) city.");
      return false;
    }

    // 3. Same city check
    if (destinationLocationId == arrivalLocationId) {
      _showError("Departure and Arrival cities cannot be the same.");
      return false;
    }

    // 4. Hotel selection check

    // 5. From date check
    if (fromDate.isEmpty) {
      _showError("Please select a start date.");
      return false;
    }

    // 6. To date check
    if (toDate.isEmpty) {
      _showError("Please select an end date.");
      return false;
    }

    // 7. Date logic check (end must be after start)
    int totalDays = getDaysBetween(fromDate, toDate);
    if (totalDays <= 0) {
      _showError("End date must be after the start date.");
      return false;
    }

    // 8. Time schedule check (at least one time slot OR specific time must be filled)
    bool anyTimeSelected = Before6AM || SixToTwelve || TwelveToSix || After6PM;
    bool specificTimeFilled = isSpecificTime && fromTime.isNotEmpty && toTime.isNotEmpty;
    if (!anyTimeSelected && !specificTimeFilled) {
      _showError("Please select at least one time slot or enter a specific time.");
      return false;
    }

    // 9. Specific time: both FROM and TO required
    if (isSpecificTime && (fromTime.isEmpty || toTime.isEmpty)) {
      _showError("Please enter both 'From' and 'To' times for the specific time slot.");
      return false;
    }

    // 10. At least one service required
    if (!isSelectflight && !isSelectHotel && !isSelectTrains && !isSelectOther) {
      _showError("Please select at least one required service (Flight, Hotel, Trans, or Other).");
      return false;
    }

    // 11. Other text required if 'Other' is checked
    if (isSelectOther && otherTextController.text.trim().isEmpty) {
      _showError("Please describe the 'Other' travel requirement.");
      return false;
    }

    return true;
  }


  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F2F8), // Light purple background
      appBar: AppBar(
        title: const Text("Employee New Trip Request",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(

        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Column(
                    children: [
                      const Text('Employee Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
                      const Divider(),
                      _summaryRow('Full Name', '${userModel?.firstName.toString()} ${userModel?.familyName.toString()}', isLink: true),
                      _summaryRow('Division', '${userModel?.division.toString()}', isLink: true),
                    ],
                  ),
                ),



                const Text(
                  'Trip Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
                 SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orangeAccent, width: 3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                          onTap:(){},
                          child:_buildTripItem(
                        icon: Icons.push_pin,
                        iconColor: Colors.red,
                        title: 'LOCATION',
                        subtitle: 'Arrival & Destination',
                      )),

                      layoutDestination(),

                      GestureDetector(
                  onTap:(){},child:_buildTripItem(
                        icon: Icons.access_time_filled,
                        iconColor: Colors.grey,
                        title: 'SCHEDULE',
                        subtitle: 'Time & Transport',
                      )),
                      const SizedBox(height: 20),
                      layoutTime(),

                      Visibility(visible:isSelectOther == true?true:false ,child: TextField(
                        controller: otherTextController,
                        maxLines: 2,
                        decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "Enter remarks"),
                      ),),
                      GestureDetector(
                          onTap:(){},child:_buildTripItem(
                        icon: Icons.calendar_month,
                        iconColor: Colors.brown,
                        title: 'DATES',
                        subtitle: 'Days',
                      )),
                      const SizedBox(height: 20),
                      layoutday(),
                    ],
                  ),
                ),
              ],
            ),
          ),


              Padding(padding: EdgeInsets.only(left: 30,right: 30,bottom: 30,),child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B53D3),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    if (_validateForm()) {
                      postAddTripRequestApi();
                    }


                  },
                  child: const Text("Submit Request",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),)
            ],
          ),
        ),
      ),
    );
  }


  Widget layoutDestination(){return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("From *", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
        _buildSearchField("Destination", (selection) {

          setState(() {
            destinationLocation = selection;


          });
          setState(() => arrivalLocation = selection);
        }),
        const SizedBox(height: 10),
        const Text("To *", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
        _buildSearchField("Arrival", (selection) {
         setState(() {
           arrivalLocation = selection;


         });



        }),

        const SizedBox(height: 20),
        DropdownButtonFormField<HotelCityItem>( // 1. Change type from String to CityItem
          value: _selectedHotel,
          decoration: const InputDecoration(
            labelText: "Select Hotel",
            border: OutlineInputBorder(),

          ),
          // 2. Ensure value: option is passed as the CityItem object
          items: hotelList.map((HotelCityItem option) {
            return DropdownMenuItem<HotelCityItem>(
              value: option,
              child: Text(option.HotelName ?? "Unknown"), // Handle null safety
            );
          }).toList(),
          // 3. Remove '.n' and ensure _selectedHotel is of type CityItem?
          onChanged: (HotelCityItem? val) {
            setState(() {
              _selectedHotel = val;
            });
          },
          validator: (val) => val == null ? "Select a category" : null,
        ),



      Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildRadioButton('One Way'),
            _buildRadioButton('Two Way'),
            _buildRadioButton('Multi City'),
          ],
        ),
      ),

        const SizedBox(height: 15),
        const Text("Remarks:", style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          controller: commentController,
          maxLines: 2,
          decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "Enter remarks"),
        ),
        const SizedBox(height: 20),

      ],
    ),
  );}

  Widget layoutday(){return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'TRIP DURATION',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 20),
    GestureDetector(
      onTap: () => _selectDate(context,"FROM"), // PASSING SETTER HERE
      child: _buildDateInputField(fromDate)),
        const SizedBox(height: 15),
    GestureDetector(
      onTap: () => _selectDate(context,"toDate"), // PASSING SETTER HERE
      child: _buildDateInputField(toDate)),

      ],
    ),
  );}


  Widget _buildRadioButton(String value) {
    return Column(
      children: [
        Radio<String>(
          value: value,
          groupValue: _selectedTrip,
          activeColor: Colors.blueAccent,
          onChanged: (String? newValue) {
            setState(() {
              print("object"+ newValue.toString());

              _selectedTrip = newValue!;
            });
          },
        ),
        Text(
          value,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget layoutTime(){return Padding(
    padding: const EdgeInsets.only(left: 20,right: 20),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'TIME SCHEDULE',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),

        // --- CONDITIONAL UI: GRID VS TIME PICKER ---
        if (!isSpecificTime) ...[
          Row(
            children: [

              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    if(Before6AM)
                    {
                      Before6AM = false;
                    }
                    else{
                      Before6AM = true;
                    }


                     setState(() {

                     });



                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Before6AM == true ? Colors.blue : Colors.black12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('🌄 Before 6AM', style: const TextStyle(color: Colors.black87, fontSize: 12)),
                ),
              ),


              const SizedBox(width: 10),

              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    if(SixToTwelve)
                    {
                      SixToTwelve = false;
                    }
                    else{
                      SixToTwelve = true;
                    }


                    setState(() {

                    });






                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: SixToTwelve == true ? Colors.blue : Colors.black12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('☀️ 6AM-12PM', style: const TextStyle(color: Colors.black87, fontSize: 12)),
                ),
              ),

            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [

              Expanded(
                child: OutlinedButton(
                  onPressed: () {


                    if(TwelveToSix)
                    {
                      TwelveToSix = false;
                    }
                    else{
                      TwelveToSix = true;
                    }


                    setState(() {

                    });




                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: TwelveToSix == true ? Colors.blue : Colors.black12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('🌆 12PM-6PM', style: const TextStyle(color: Colors.black87, fontSize: 12)),
                ),
              ),

              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {

                    if(After6PM)
                    {
                      After6PM = false;
                    }
                    else{
                      After6PM = true;
                    }


                    setState(() {

                    });
                    },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: After6PM == true ? Colors.blue : Colors.black12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('🌙 After 6PM', style: const TextStyle(color: Colors.black87, fontSize: 12)),
                ),
              ),

            ],
          ),
        ] else ...[
          GestureDetector(
            onTap: () => _selectTime(context,"FROM"), // PASSING SETTER HERE
            child: _buildTimeInputField(fromTime),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text('to', style: TextStyle(fontSize: 16)),
          ),
          GestureDetector(
            onTap: () => _selectTime(context,"To"), // PASSING SETTER HERE
            child: _buildTimeInputField(toTime),
          ),
        ],
        // ------------------------------------------

        const SizedBox(height: 10),
        Center(
          child: Column(
            children: [
              Checkbox(
                value: isSpecificTime,
                onChanged: (val) {
                  if(isSpecificTime)
                    {
                      isSpecificTime = false;
                    }
                  else{
                    isSpecificTime = true;
                  }
                  setState(() {

                  });
                },


              ),
              const Text('Specific Time'),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Text('REQUIRED', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _labeledCheckbox('Flight', isSelectflight),
            _labeledCheckbox('Hotel', isSelectHotel),
            _labeledCheckbox('Trans', isSelectTrains),
            _labeledCheckbox('Other', isSelectOther),
          ],
        ),
        const SizedBox(height: 20),

      ],
    ),
  );}



  Widget _buildSearchField(String hint, Function(String) onSelected) {
    return Autocomplete<CityItem>(
      // 1. Tell Flutter how to turn the Object into a String for the text field
      displayStringForOption: (CityItem option) => option.cityName.toString(),

      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<CityItem>.empty();
        }

        // 2. Filter based on a property of your CityItem
        return locationList.where((CityItem option) {
          return option.cityName!
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },

      onSelected: (CityItem selection) {

        if(hint == "Arrival"){
          arrivalLocation = selection.cityName.toString();
          arrivalLocationId = selection.iD.toString();
          getHotelByCityApiApi();
        }
        else{

          destinationLocation = selection.cityName.toString();
          destinationLocationId = selection.iD.toString();

        }

        onSelected(selection.cityName.toString());

      },
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



  Widget _labeledCheckbox(String label, bool value) {
    return Column(
      children: [
        Checkbox(value: value, onChanged: (val) {

          if(label == "Hotel"){
            if(isSelectHotel == true)
            {
              isSelectHotel = false!;
            }
            else{
              isSelectHotel = true!;
            }
          }
          else if(label == "Flight"){
            if(isSelectflight == true)
              {
                isSelectflight = false!;
              }
            else{
              isSelectflight = true!;
            }


          }
          else if(label == "Trans"){
            if(isSelectTrains == true)
            {
              isSelectTrains = false!;
            }
            else{
              isSelectTrains = true!;
            }

          }
          else{
            if(isSelectOther == true)
            {
              isSelectOther = false!;
            }
            else{
              isSelectOther = true!;
            }
          }
          setState(() {

          });
        }, activeColor: Colors.blue),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
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


  Widget _buildTripItem({required IconData icon, required Color iconColor, required String title, required String subtitle}) {
    return Row(
      children: [
        Icon(icon, size: 30, color: iconColor),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
            Text(subtitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }

  Future<void> _selectTime(BuildContext context ,String toselect) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if(toselect == "FROM") {
      if (picked != null) {
        // Update the Dialog UI immediately

        // Also update the underlying parent state if needed
        setState(() {
          fromTime = picked.format(context);
        });
      }
    }
    else{
      if (picked != null) {
        // Update the Dialog UI immediately


        // Also update the underlying parent state if needed
        setState(() {
          toTime = picked.format(context);
        });
      }
    }
  }

  Future<void> _selectDate(BuildContext context, String toselect) async {
    // 1. Aaj ki date default rakhte hain
    FocusScope.of(context).unfocus();
    DateTime initialDate;
    DateTime firstDate;
    if (toselect == "FROM") {
      initialDate = DateTime.now();
      firstDate = DateTime.now();

    } else {
      List<String> parts = fromDate.split('-');

      int day = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int year = int.parse(parts[2]);

      DateTime convertedDate = DateTime(year, month, day);

      initialDate = convertedDate;
      firstDate = convertedDate;
    }




    // 2. Agar "TO" date select kar rahe hain
    if (toselect == "TO" && fromDate.isNotEmpty) {
      try {
        // String "12-03-2026" ko Tod kar parts mein divide karna
        List<String> parts = fromDate.split('-');
        int d = int.parse(parts[0]);
        int m = int.parse(parts[1]);
        int y = int.parse(parts[2]);

        // Ye rahi aapki selected From Date
        DateTime selectedFromDate = DateTime(y, m, d);

        // AB MAIN LOGIC:
        // firstDate ko selectedFromDate set kar do.
        // Isse calendar usse purani (11, 10 March) dates ko block kar dega.
        firstDate = selectedFromDate;
        initialDate = selectedFromDate;

      } catch (e) {
        print("Parsing error: $e");
      }
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate, // YAHI VO LINE HAI JO 11 MARCH KO DISABLE KAREGI
      lastDate: DateTime(2100),
      helpText: 'SELECT ${toselect.toUpperCase()} DATE',
    );

    if (picked != null) {
      setState(() {
        // Date ko format karke save karna (03-03-2026 format)
        String formattedDate = "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";

        if (toselect == "FROM") {
          fromDate = formattedDate;
          // Jab "FROM" badle, toh "TO" ko reset kar dena chahiye safety ke liye
          toDate = "";
        } else {
          toDate = formattedDate;





        }
      });

      int totalDays = getDaysBetween(fromDate, toDate);

      if (totalDays <= 7){
        print("====="+ totalDays.toString());
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text("Long-term trip detected: $totalDays days")),
        );
      }


    }
  }


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

