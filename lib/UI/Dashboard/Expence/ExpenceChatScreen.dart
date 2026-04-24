import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfirstdemo/Utilities/Util.dart';
import '../../../Model/ExpenceChatModel.dart';
import '../../../Model/LoginResponce.dart';
import '../../../Services/ApiServices/GlobalLoader.dart';
import '../../../Services/ApiServices/SecureStorageService.dart';
import 'ExpenceController.dart';

class ExpenceChatScreen extends StatefulWidget {
  var  tripId;

  ExpenceChatScreen({super.key,required this.tripId});
  @override
  State<ExpenceChatScreen> createState() => _ExpenceChatScreenState();
}

class _ExpenceChatScreenState extends State<ExpenceChatScreen> {

  late final ExpenceController dashboardController = Get.put(ExpenceController());
  final SecureStorageService _storageService = SecureStorageService();

   List<ChatData> _messages = [];
   String userid = "";

  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.isEmpty) return;
    setState(() {

      postExpenceChatListApi();


      _messages.insert(0, ChatData(id: 0, tripExpenceId: 0, text: _controller.text.toString() , createdBy: int.parse(userid), createdDate: DateTime.now().toString(), createdTime: '', rplyType: '', activeName: ''));
    });

  }


  @override
  void initState() {

    getChatExpenceListApi();
    super.initState();

  }

  @override
  void dispose() {

    super.dispose();
  }


  getChatExpenceListApi() async {

    userid = (await _storageService.getUserId())!;
    showLoader(context);
    try {

      // Assuming this returns an instance of VerifyOtpResponse
      ExpenceChatModel? expenceModel = await dashboardController.GetExpenceChatListApi(tripId: widget.tripId.toString()

      );

      if (mounted) {
        dismissLoader(context);
        // Small delay to ensure loader is gone before UI updates or navigation
        await Future.delayed(Duration(milliseconds: 100));

        if (expenceModel != null ) {

          _messages = expenceModel.data!.reversed.toList();

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
  postExpenceChatListApi() async {
    showLoader(context);
    try {
      String? userId = await _storageService.getUserId();
      // Assuming this returns an instance of VerifyOtpResponse
      LoginResponce? expenceModel = await dashboardController.postExpenceChatListApi(tripId: widget.tripId.toString(), userId: userId.toString(), textChat: _controller.text

      );

      if (mounted) {
        dismissLoader(context);
        // Small delay to ensure loader is gone before UI updates or navigation
        await Future.delayed(Duration(milliseconds: 100));

        if (expenceModel != null ) {



        _controller.text = "";


          setState(() {

          });


        }
        else {

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
    return Scaffold(
      appBar: AppBar(title: const Text("Chat Expense")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true, // Keep newest messages at the bottom
              padding: EdgeInsets.all(10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];

                return Align(
                  alignment: msg.createdBy.toString() == userid.toString()
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: msg.createdBy.toString() == userid.toString()
                          ? Colors.blue
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    // Use an IntrinsicWidth to prevent the bubble from stretching to full width
                    child: IntrinsicWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end, // This forces items to the right
                        children: [
                          Text(
                            msg.text,
                            style: TextStyle(
                              color: msg.createdBy.toString() == userid.toString()
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4), // Add a little space between text and date
                          Text(
                            getFormattedDateAndTimeFromUTC(msg.createdDate.toString()),
                            textAlign: TextAlign.right, // Ensures text inside aligns right
                            style: TextStyle(
                              color: msg.createdBy.toString() == userid.toString()
                                  ? Colors.white70
                                  : Colors.black54,
                              fontSize: 10, // Dates usually look better smaller
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Input Area
          Container(
            color: Colors.blue,
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Enter message...",
                      // This creates the rounded shape
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none, // Optional: removes the default line
                      ),
                      filled: true,
                      fillColor: Colors.grey[200], // Background color for the rounded field
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                Container(

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                  ),

                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: _sendMessage,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}