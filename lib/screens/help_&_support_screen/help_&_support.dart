import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:product_iq/screens/help_&_support_screen/help_support_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../consts.dart';

class HelpSupportScreen extends GetView<HelpSupportScreen> {
  // final TextEditingController _controller = TextEditingController();

  HelpSupportController helpSupportController =
      Get.put(HelpSupportController());


  void postMessage(String? answer, BuildContext context) async {
    // Check if the answer is null or empty
    if (answer == null || answer.isEmpty) {
      // _showSnackBarMessage('Please answer the question', context);
      return;
    }

    // Retrieve the token if not already set
    if (MyConsts.token.isEmpty) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      MyConsts.token = preferences.getString("token") ?? '';
      if (MyConsts.token.isEmpty) {
        // _showSnackBarMessage('Token is missing', context);
        return;
      }
    }

    // Construct the API URL
    final postAnswerUrl = Uri.parse('${MyConsts.baseUrl}/app/add-contactus');

    // Prepare the request body
    final requestBody = json.encode({
      'message': answer,
      'name': 'hemant',
    });

    try {
      // Make the HTTP POST request
      http.Response response = await http.post(
        postAnswerUrl,
        headers: MyConsts.requestHeader,
        body: requestBody,
      );


      // Decode the response body
      final res = jsonDecode(response.body);

      // Handle the response
      if (response.statusCode == 200) {
        debugPrint("Response: $res");
        // showRatingDialog(context, 0.0);
      } else if (response.statusCode == 400) {
        // _showSnackBarMessage(res['message'] ?? 'Bad request', context);
      } else if (response.statusCode == 403) {
        // _showSnackBarMessage(res['error'] ?? 'Forbidden', context);
      } else {
        // _showSnackBarMessage(
        //   res['error'] ?? res['message'] ?? 'Something went wrong',
        //   context,
        // );
        debugPrint("Error Response: ${response.body}");
      }
    } catch (e) {
      // Handle exceptions such as network errors
      // _showSnackBarMessage('An error occurred: $e', context);
      debugPrint("Exception: $e");
    }
  }



  @override
  Widget build(BuildContext context) {
    helpSupportController.messageHistory();
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(color: MyConsts.bgColor),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: const Icon(Icons.arrow_back)),
          title: Text(
            "Help & Support",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              MyConsts.primaryColorFrom,
              MyConsts.primaryColorTo
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Container(
              color: MyConsts.bgColor,
              child: TabBar(
                labelColor: MyConsts.productColors[3][0],
                labelStyle: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontSize: 15),
                unselectedLabelStyle: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontSize: 15),
                unselectedLabelColor: Colors.grey,
                indicatorColor: MyConsts.productColors[3][0].withOpacity(0.4),
                automaticIndicatorColorAdjustment: false,
                overlayColor: MaterialStateProperty.resolveWith(
                    (states) => Colors.grey.shade300),
                controller: helpSupportController.tabController,
                tabs: [
                  Tab(
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 2,
                      child: const Text("FAQ"),
                    ),
                  ),
                  Tab(
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: const Text("Contact Us"),
                    ),
                  ),
                ],
                onTap: (index) {
                  helpSupportController.changeTabIndex(index);
                },
              ),
            ),
          )),
      backgroundColor: MyConsts.bgColor,
      persistentFooterAlignment: AlignmentDirectional.center,
      body: TabBarView(
          controller: helpSupportController.tabController,
          children: [
            ListView.builder(
              itemCount: helpSupportController.faqList.length ,
              itemBuilder: (context, index) {
                String question = helpSupportController.faqList[index]['question']!;
                String answer = helpSupportController.faqList[index]['answer']!;
                // print("object ${faqList.length}");
                return InkWell(
                  onTap: () {
                    helpSupportController.toggleExpansion(index);
                  },
                  child: Obx(
                          () {
                        return Container(
                          margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
                          width: MediaQuery.of(context).size.width - 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10,top: 10,bottom: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        question,
                                        maxLines: 4,
                                        softWrap: true,
                                        overflow: TextOverflow.visible,
                                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                          fontSize: 15 ,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600 ,
                                        ) ,
                                      ),
                                    ) ,
                                    const Icon(Icons.expand_more) ,
                                  ],
                                ),
                              ),
                              if (helpSupportController.openOrderItems[index])
                                Padding(
                                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10,bottom: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Text(
                                        answer,maxLines: 6,softWrap: true, style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                          fontSize: 14,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),

                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        );

                          }
                  ),
                );
              },
            ),
        Column(
          children: <Widget>[

            Expanded(
              child:Obx(() {
                return ListView.builder(
                  controller: helpSupportController.scrollController,
                  itemCount: helpSupportController.contactUsList.length,
                  itemBuilder: (context, index) {
                    final message = helpSupportController.contactUsList[index];
                    final isOutgoing = message.replay == 'None';
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(index==0)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.75,
                            ),
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(0),
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                ),
                              ),
                              child: IntrinsicWidth(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "How can I help you ?",
                                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    // Align(
                                    //   alignment: Alignment.bottomRight,
                                    //   child: Text(
                                    //     "04:08 PM",
                                    //     style: Theme.of(context).textTheme.caption!.copyWith(
                                    //       fontSize: 10,
                                    //       color: Colors.grey,
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.75,
                            ),
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                              padding: const EdgeInsets.all(10.0),
                              decoration: const BoxDecoration(
                                color: Color(0xFFD8D4D4),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                  topRight: Radius.circular(0),
                                ),
                              ),
                              child: IntrinsicWidth(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      message.message,
                                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    // Align(
                                    //   alignment: Alignment.bottomRight,
                                    //   child: Text(
                                    //     "04:08 PM",
                                    //     style: Theme.of(context).textTheme.caption!.copyWith(
                                    //       fontSize: 10,
                                    //       color: Colors.grey,
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        if (!isOutgoing)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.75,
                              ),
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(0),
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                ),
                                child: IntrinsicWidth(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        message.replay,
                                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      // Align(
                                      //   alignment: Alignment.bottomRight,
                                      //   child: Text(
                                      //     "04:08 PM",
                                      //     style: Theme.of(context).textTheme.caption!.copyWith(
                                      //       fontSize: 10,
                                      //       color: Colors.grey,
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                );
              })
            ),
            Obx(
               () {
                return helpSupportController.contactUsList.isEmpty ?Align(
                    alignment: Alignment.centerLeft,
                    child: ConstrainedBox(
                    constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(0),
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                    topRight: Radius.circular(8),
                    ),
                    ),
                    child: IntrinsicWidth(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text(
                    "How can I help you ?",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    ),
                    ),
                    const SizedBox(height: 4),
                    // Align(
                    //   alignment: Alignment.bottomRight,
                    //   child: Text(
                    //     "04:08 PM",
                    //     style: Theme.of(context).textTheme.caption!.copyWith(
                    //       fontSize: 10,
                    //       color: Colors.grey,
                    //     ),
                    //   ),
                    // ),
                    ],
                    ),
                    ),
                    ),
                    ),
                    )
                        :const SizedBox.shrink();
              }
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0,bottom: 10,right: 15,left: 15),
              child: TextField(
                controller: helpSupportController.textEditingController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: MyConsts.bgColor,
                  contentPadding: const EdgeInsets.only(left: 20, right: 10, top: 5, bottom: 15),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade700),
                        borderRadius: BorderRadius.circular(30),
                      ),
                  hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                  hintText: 'Message...',
                  suffixIcon: IconButton(onPressed: () {
                    // postMessage("hemant", context);
                    if(helpSupportController.textEditingController.text ==""){
                      helpSupportController.showSnackBarMessage("Please Enter Message...", context);
                    }else{

                     helpSupportController.postMessage(helpSupportController.textEditingController.text, context);
                    }
                  },icon: const Icon(Icons.send),),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  // suffixIcon: Icon(Icons.send), // Optional: to show an icon when typing
                ),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
    fontSize: 15,
    color: Colors.black54,
    fontWeight: FontWeight.w500,
    ),
                textInputAction: TextInputAction.go, // Set action to 'Go'
                onSubmitted: (text) {
                  if(helpSupportController.textEditingController.text ==""){
                    helpSupportController.showSnackBarMessage("Please Enter Message...", context);
                  }else{

                    helpSupportController.postMessage(helpSupportController.textEditingController.text, context);
                  }
                },
              ),
            ),
          ],
        )



        ]),
    );
  }

  void copyToClipboard(BuildContext context) {
    Clipboard.setData(const ClipboardData(text: "PRO123")).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Referral code copied to clipboard!')),
      );
    });
  }
}
