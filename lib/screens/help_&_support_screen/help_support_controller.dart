import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:product_iq/models/contactUs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../consts.dart';
import 'package:http/http.dart' as http;


class HelpSupportController extends GetxController with SingleGetTickerProviderMixin{
  late TabController tabController ;
  var contactUsList = <ContactUsMessage>[].obs;
  var contactUsList1 = <ContactUsMessage>[].obs;
  var tabIndex = 0.obs;
  final ScrollController scrollController = ScrollController();
  var messageContact= "";
  var name = "";
  var isSubmitting= false;
  var faqList = <Map<String, dynamic>>[
    {
      'question': "Is ProductQ right for me?",
      'answer': "ProductQ accelerates your growth as a Product Manager, offering up to a 10X improvement or a quicker career switch with higher hikes. With self-paced, engaging industry challenges and real-time skill-report, it's tailored for engineers, product designers, data analysts, business analysts, marketers, and salespersons, ensuring you avoid boring classes.",
      'expanded': false
    },
    {
      'question': "Which one should I choose: Product Industry Trainer or Product Interview Coach?",
      'answer': "If you're an existing or aspiring PM aiming to enhance and solidify your skills, for demanding hikes, the Product Industry Trainer is ideal for you. For those preparing for a PM interview, the Product Interview Coach offers targeted preparation to ensure success.",
      'expanded': false
    },
    {
      'question': "Is the Product Industry Trainer only for experienced PMs?",
      'answer': "The Product Industry Trainer is perfect for both experienced PMs and aspiring professionals. It helps build robust all-round product skills from product discovery to strategy, making you industry-ready and able to command higher salaries.",
      'expanded': false
    },
    {
      'question': "How is the content delivered in ProductQ programs?",
      'answer': "The modules are crafted by industry experts consisting of challenges to solve in a self-paced manner. Each challenge consist a set of questions covering all product concepts with hints and sample answer. Once answer is submitted, a skill report is generated instantly.",
      'expanded': false
    },
    {
      'question': "How does ProductQ differ from other product management training platforms?",
      'answer': "ProductQ focuses on solving actual industry problems with real-time skill reports. Our expert-designed modules cover the entire product lifecycle, unlike other programs that miss critical product aspects and rely on slow classes. ProductQ provides a comprehensive, self-paced learning experience.",
      'expanded': false
    },
    {
      'question': "What plans are available?",
      'answer': "Choose from a 4-month quarterly subscription to complete the Product Industry Trainer or Product Interview Coach programs. Alternatively, you can opt for a monthly subscription if you prefer a pay-per-use model.",
      'expanded': false
    },
    {
      'question': "What are the prerequisites for enrolling in ProductQ programs?",
      'answer': "There are no strict prerequisites. Our programs are designed to be accessible to both beginners and those with experience in product management. We'll tailor the learning experience to your current level and goals.",
      'expanded': false
    },
    {
      'question': "Is there a free trial available?",
      'answer': "Yes, we offer one challenge free from a module to try the real-time support and skill report.",
      'expanded': false
    },
    {
      'question': "Whom can I reach out to for more queries?",
      'answer': "For any questions, feel free to contact our customer specialist at support@productq.app.",
      'expanded': false
    },
    {
      'question': "What is the cancellation and money-back policy?",
      'answer': "If you wish to cancel, you can email support@productq.app within 7 days to receive a refund and discontinue your ProductQ subscription.",
      'expanded': false
    },
    {
      'question': "Are there any discounts for group enrollments or corporate training?",
      'answer': "Yes, we offer discounts for group enrollments and corporate training packages. Please contact our sales team at support@productq.app for more details and a customized quote.",
      'expanded': false
    },
    {
      'question': "Can I switch between the Product Industry Trainer and Product Interview Coach programs?",
      'answer': "Yes, you can switch between programs. If you find that your career goals have changed, simply contact our support team at support@productq.app to discuss the best option for you.",
      'expanded': false
    }
  ].obs;
  var messages = <Map<String, dynamic>>[
    {'id':"2",'text': 'Hello! How can I help you today?', 'type': 'incoming','time': DateFormat('hh:mm a').format(DateTime.now())
    }
  ].obs;

  var openOrderItems = List<bool>.filled(12, false).obs;

  void onInit() {
    super.onInit();
    loadDetails();
    // contactUsList.add(messages as ContactUsMessage);
    messageHistory();
    ever(contactUsList, (_) => _scrollToBottom());
    tabController= TabController(length: 2, vsync: this);
    tabController.addListener(() {
      tabIndex.value = tabController.index;
    });
  }
  void changeTabIndex(int index){
    tabIndex.value = index;
    tabController.animateTo(index);
  }
   void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  final TextEditingController textEditingController = TextEditingController();

  void sendMessage(String text) {
    if (text.isNotEmpty) {
      contactUsList.add(ContactUsMessage(id: 0, name: name, message: textEditingController.text, replay: 'None'));
      textEditingController.clear();
    }
  }
  void toggleExpansion(int index){
    for (int i = 0; i < openOrderItems.length; i++) {
      if (i == index) {
        openOrderItems[i] = !openOrderItems[i];
      } else {
        openOrderItems[i] = false;
      }
    }
  }

  void loadDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name') ?? '';

  }


  void _showSnackBarMessage(String message,context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
  void postMessage(String? answer,context) async {
    if (textEditingController.text == null ) {
      _showSnackBarMessage('Please answer the question',context);
        isSubmitting = false;
      return;
    }
    if (MyConsts.token == '') {
      SharedPreferences preferences = await SharedPreferences.getInstance();
        MyConsts.token = preferences.getString("token")!;
    }
    final postAnswerUrl = Uri.parse(
        '${MyConsts.baseUrl}/app/add-contactus');
    // print("$postAnswerUrl");
    http.Response response = await http.post(postAnswerUrl,
        headers: MyConsts.requestHeader, body: json.encode({'message': textEditingController.text,'name':name}));
    // print("response${ response.body}");
    final res = jsonDecode(response.body);
    if (response.statusCode == 200) {
      sendMessage(textEditingController.text);
      debugPrint(res.toString());
        isSubmitting = false;

      // showRatingDialog(context, 0.0);

    } else if (response.statusCode == 400) {
      print("message -----${res['message']}");
      _showSnackBarMessage(res['message'],context);
        isSubmitting = false;
    } else if (response.statusCode == 403) {
      _showSnackBarMessage(res['error'],context);
        isSubmitting = false;
    } else {
      if (res['error'] != null){
        _showSnackBarMessage(res['error'],context);
      } else if (res['message'] != null) {
        _showSnackBarMessage(res['message'],context);
      } else {
        _showSnackBarMessage('Something went wrong',context);
      }
      debugPrint(response.body);
        isSubmitting = false;
    }
  }
  void showSnackBarMessage(String message,context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
  void messageHistory() async {

    if (MyConsts.token == '') {
      SharedPreferences preferences = await SharedPreferences.getInstance();
        MyConsts.token = preferences.getString("token")!;
    }
    final postAnswerUrl = Uri.parse(
        '${MyConsts.baseUrl}/app/view-contactus');
    http.Response response = await http.get(postAnswerUrl,
        headers: MyConsts.requestHeader );
    print("message history----response${response.body}");
    final res = jsonDecode(response.body);
    if (response.statusCode == 200) {
      contactUsList1.value = contactUsMessageFromJson(response.body);
      print(contactUsList);
      contactUsList.addAll(contactUsList1);

        isSubmitting = false;

      // showRatingDialog(context, 0.0);

    } else if (response.statusCode == 400) {
      print("message -----${res['message']}");
      // _showSnackBarMessage(res['message'],context);
        isSubmitting = false;
    } else if (response.statusCode == 403) {
      // _showSnackBarMessage(res['error'],context);
        isSubmitting = false;
    } else {
      if (res['error'] != null){
        // _showSnackBarMessage(res['error'],context);
      } else if (res['message'] != null) {
        // _showSnackBarMessage(res['message'],context);
      } else {
        // _showSnackBarMessage('Something went wrong',context);
      }
      debugPrint(response.body);
        isSubmitting = false;
    }
  }

  @override
  void onClose() {
    textEditingController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}