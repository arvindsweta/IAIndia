import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:myfirstdemo/Model/VerifyOtpResponse.dart';
import 'package:myfirstdemo/Services/ApiServices/GlobalLoader.dart';
import 'package:myfirstdemo/Services/ApiServices/SecureStorageService.dart';
import 'package:myfirstdemo/UI/Dashboard/DashboardScreen.dart';
import 'package:myfirstdemo/UI/LoginScreen/LoginController.dart';
import 'package:get/get.dart';
import 'package:myfirstdemo/UI/SecurityDashboard/MenuDrawer/SecurityDashbordController.dart';

import '../../UI/SecurityDashboard/MenuDrawer/MainNavigationPage.dart';


class OtpPopup extends StatefulWidget {
  var username;
  var password;
  OtpPopup({super.key,required this.username,required this.password});

  @override
  State<OtpPopup> createState() => _OtpPopupState();
}

class _OtpPopupState extends State<OtpPopup> {
  late final SecurityDashbordController securityDashbordController = Get.put(SecurityDashbordController());
  final SecureStorageService _storageService = SecureStorageService();
  int _secondsRemaining = 30;
  bool _canResend = false;
  Timer? _timer;
  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    if (_timer != null) _timer!.cancel();
    setState(() {
      _secondsRemaining = 30;
      _canResend = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_secondsRemaining > 0) {
            _secondsRemaining--;
          } else {
            _canResend = true;
            _timer?.cancel();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }


  postVerifyUserApi() async {
    showLoader(context);
    try {
      // Assuming this returns an instance of VerifyOtpResponse
      VerifyOtpResponse? dataModel = await securityDashbordController.userSecureLoginVerifyotp(userEmail: widget.username.toString(), Password: widget.password.toString(), otp: _otpController.text.toString()

      );

      if (mounted) {
        dismissLoader(context);
        // Small delay to ensure loader is gone before UI updates or navigation
        await Future.delayed(Duration(milliseconds: 100));

        if (dataModel != null && dataModel.d != null) {
          // Now dataModel.d is a proper Map: {"UserID": "1575-Mahesh Singh-IAI CORP"}
          String rawUserID = dataModel.d!['UserID']?.toString() ?? "";

          if (rawUserID.isNotEmpty) {
            // 2. Split the hyphenated string
            List<String> parts = rawUserID.split('-');

            // 3. Validation and Assignment
            if (parts.length >= 3) {
              String id = parts[0].trim();
              String name = parts[1].trim();
              String company = parts[2].trim();
              print("Successfully Parsed -> ID: $id, Name: $name, Co: $company");

              await _storageService.saveUserId(id);
              await _storageService.writeCompany(company);
              await _storageService.writeUsername(name);
              await _storageService.writeUserLogin("true");
              await _storageService.writeUserLoginType("Security");



              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialWithModalsPageRoute(
                      builder: (context) => MainNavigationPage()),
                      (Route<dynamic> route) => false);

              // Success!




            } else {
              print("UserID format incorrect. Expected 3 parts, got: ${parts.length}");
            }
          } else {
            print("UserID key not found in response 'd'");
          }
        } else {
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
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text("Verify OTP", textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Enter the 6-digit code sent to your device."),
          const SizedBox(height: 25),

          // Single TextField for OTP
          TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 6,
            // Letter spacing makes a single field look like separate boxes
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 15.0,
            ),
            decoration: InputDecoration(
              counterText: "", // Hides the character counter
              hintText: "000000",
              hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5), letterSpacing: 15.0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (value) {
              if (value.length == 6) {
                // Optional: Auto-hide keyboard when 6 digits are reached
                FocusScope.of(context).unfocus();
              }
            },
          ),

          const SizedBox(height: 25),
          _canResend
              ? TextButton(
            onPressed: _startTimer,
            child: const Text("Resend Code",
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          )
              : Text("Resend in $_secondsRemaining seconds",
              style: const TextStyle(color: Colors.grey)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_otpController.text.length == 6) {
              print("Submitting OTP: ${_otpController.text}");
              postVerifyUserApi();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please enter a 6-digit code")),
              );
            }
          },
          child: const Text("Verify"),
        ),
      ],
    );
  }
}