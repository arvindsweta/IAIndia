import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:myfirstdemo/Model/LoginResponce.dart';
import 'package:myfirstdemo/Model/VerifyOtpResponse.dart';
import 'package:myfirstdemo/Services/ApiServices/GlobalLoader.dart';
import 'package:myfirstdemo/Services/ApiServices/SecureStorageService.dart';
import 'package:myfirstdemo/UI/Dashboard/DashboardScreen.dart';
import 'package:myfirstdemo/UI/LoginScreen/LoginController.dart';
import 'package:get/get.dart';
import 'package:myfirstdemo/UI/SecurityDashboard/MenuDrawer/MainNavigationPage.dart';
import 'package:myfirstdemo/UI/SecurityDashboard/MenuDrawer/SecurityDashbordController.dart';
import 'package:myfirstdemo/Widgets/CustomWidgets.dart';
import 'package:myfirstdemo/Widgets/Toast/OtpPopup.dart';

import '../../constants/Assets.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  bool isEmployee = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  late final LoginController postUserController = Get.put(LoginController());
  late final SecurityDashbordController SecureController = Get.put(SecurityDashbordController());
  final SecureStorageService _storageService = SecureStorageService();


  final _formKey = GlobalKey<FormState>();
  bool isEmployeeLogin = true;
  bool isSuccesOtp = false;

  String LoginUser = "EMP";

  @override
  void initState() {

    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

/// Security Login
  postSecurityVerifyUserApi() async {
    showLoader(context);
    try {
      // Assuming this returns an instance of VerifyOtpResponse
      VerifyOtpResponse? dataModel = await SecureController.userSecureLoginVerifyotp(userEmail:_emailController.text.toString(), Password: "", otp: _otpController.text.toString()

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



  postSecurityLoginUserApi() async {
    showLoader(context);
    try {
      LoginResponce? dataModel  = await SecureController.postSecurityLoginApi(userEmail: _emailController.text!.toString(), Password: ""
      );

      if (mounted) {
        // Pop the loader dialog
        dismissLoader(context);

        // Wait for the pop animation to complete


        if (dataModel != null) {

          print('The value is: ${dataModel.d}');
          if (dataModel.d == "Invalid") {

            print('The value is: ${dataModel.d}');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Invalid Login Credentials")),
            );
            // Navigate to Home or show success

          } else {

            isSuccesOtp = true;
            setState(() {

            });



            /*WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) =>  OtpPopup(username: _emailController.text,password: _passwordController.text,),
              );
            });*/

            print("Login Successful!");
            setState(() {

            });
          }
        }
      }
    } catch (e) {
      print("Error: $e");
      if (mounted) {
        dismissLoader(context);
      }
    }
  }

  postUserApi() async {
    showLoader(context);
    try {
      LoginResponce? dataModel  = await postUserController.postUserLoginApi(userEmail: _emailController.text!.toString()
      );

      if (mounted) {
        // Pop the loader dialog
        dismissLoader(context);

        // Wait for the pop animation to complete


        if (dataModel != null) {

          print('The value is: ${dataModel.d}');
          if (dataModel.d == "Invalid") {

            print('The value is: ${dataModel.d}');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Invalid Login Credentials")),
            );
            // Navigate to Home or show success
            print("Login Successful!");
          } else {

            isSuccesOtp = true;
            setState(() {

            });
          }
        }
      }
    } catch (e) {
      print("Error: $e");
      if (mounted) {
        dismissLoader(context);
      }
    }
  }

  postVerifyUserApi() async {
    showLoader(context);
    try {
      // Assuming this returns an instance of VerifyOtpResponse
      VerifyOtpResponse? dataModel = await postUserController.userVerifyotp(
        userEmail: _emailController.text.trim(),
        otp: _otpController.text.trim(),
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
              await _storageService.writeUserLoginType("EmpSecurity");



              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialWithModalsPageRoute(
                      builder: (context) => DashboardScreen()),
                      (Route<dynamic> route) => false);

              postUserTokenApi();


              setState(() {
                isSuccesOtp = true;
                // Optional: Store these in variables to show on your UI
              });

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


  postUserTokenApi() async {

    String? userId = await _storageService.getUserId();
    String? fcmToken = await _storageService.getFCMToken();

    try {
      // Assuming this returns an instance of VerifyOtpResponse
      LoginResponce? dataModel = await postUserController.postUserEmpTokenSaveApi(
        userId: userId.toString(),
        token: fcmToken.toString(),
      );


      if (mounted) {
        // Pop the loader dialog


        // Wait for the pop animation to complete


        if (dataModel != null) {

          print('The value is: ${dataModel.d}');
          if (dataModel.d == "Success") {



          } else {



          }
        }
      }

      /*if (mounted) {
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
              await _storageService.writeUserLoginType("EmpSecurity");



              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialWithModalsPageRoute(
                      builder: (context) => DashboardScreen()),
                      (Route<dynamic> route) => false);

              // Success!


              setState(() {
                isSuccesOtp = true;
                // Optional: Store these in variables to show on your UI
              });

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

      }*/
    } catch (e) {
      print("Error in postVerifyUserApi: $e");
      if (mounted) {
        dismissLoader(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                )
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [


                  // Logo Placeholder
                  Center( child:SizedBox(width: 200,height: 110,child: imageView(
                      assetName: Assets.iailogo, fit: BoxFit.fill)),),
                  const SizedBox(height: 10),
                  const Text(
                    "Login",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const Text("Enter your credentials to continue"),
                  const SizedBox(height: 25),

                  // Toggle Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: LoginUser != "SEC" ? const Color(0xFF2B53D3) : Colors.white,
                            foregroundColor: LoginUser != "SEC" ? Colors.white : Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: (){
                            isSuccesOtp = false;
                            isEmployeeLogin = true;
                            LoginUser = "EMP";
                            setState(() {

                            });


                          },

                          //=> setState(() => isEmployeeLogin = true),
                          child: const Text("Emp Login"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: LoginUser == "SEC" ? const Color(0xFF2B53D3) : Colors.white,
                            foregroundColor: LoginUser == "SEC" ? Colors.white : Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: (){
                            isSuccesOtp = false;
                            isEmployeeLogin = true;
                            LoginUser = "SEC";
                            setState(() {

                            });

                          },
                          child: const Text("Security Login"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: "Email Id *",
                      border: OutlineInputBorder(),
                      hintText: "Enter your email",
                    ),
                    validator: (value) {
                      if (value == null || !value.contains('@')) return 'Enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Dynamic Field: OTP for Employee, Password for Agent
                  Visibility(visible:isSuccesOtp==false?false:true, child:TextFormField(
                    controller: isEmployeeLogin ? _otpController : _otpController,
                    obscureText: !isEmployeeLogin,
                    keyboardType: isEmployeeLogin ? TextInputType.number : TextInputType.text,
                    decoration: InputDecoration(
                      labelText: isEmployeeLogin ? "OTP *" : "Password *",
                      border: const OutlineInputBorder(),
                      hintText: isEmployeeLogin ? "Enter OTP" : "Enter your password",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'This field is required';
                      if (isEmployeeLogin && value.length < 4) return 'Enter valid OTP';
                      if (!isEmployeeLogin && value.length < 6) return 'Password too short';
                      return null;
                    },
                  )),

                  if (isEmployeeLogin)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text("Resend OTP", style: TextStyle(color: Colors.blue)),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2B53D3),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed:(){

                        print(LoginUser);
                        if(LoginUser =="EMP") {
                          if (isSuccesOtp == false) {
                            postUserApi();
                          }
                          else {
                            postVerifyUserApi();
                          }
                        }
                        else {

                          if (isSuccesOtp == false) {
                            postSecurityLoginUserApi();
                          }
                          else {
                            postSecurityVerifyUserApi();
                          }






                        }
                        /* Navigator.pushAndRemoveUntil(
                            context,
                            MaterialWithModalsPageRoute(
                                builder: (context) => DashboardScreen()),
                                (Route<dynamic> route) => false);*/
                      },
                      child: const Text("Submit", style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(onPressed: () {}, child: const Text("Forgot Password?")),

                    ],
                  ),

                  const Divider(),
                  const Text(
                    "© Copyright by 4techbugs All rights reserved.",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  void _showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Notice"),
          content: const Text("This is a standard alert message."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
