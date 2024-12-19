import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:product_iq/secret_constants.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../consts.dart';
import '../routes/app_route_consts.dart';

class PaymentServices {
  final Razorpay _razorpay = Razorpay(); //Instance of razor pay
  final razorPaySecret = SecretConstants.razorpaySecretKey;
  intiateRazorPay(BuildContext context) {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
        (PaymentSuccessResponse response) {
      _handlePaymentSuccess(response, context);
    });
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
        (PaymentFailureResponse response) {
      _handlePaymentError(response, context);
    });
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(
      PaymentSuccessResponse response, BuildContext context) {
    MyConsts.isPurchased = true;
    GoRouter.of(context).pushReplacementNamed(MyAppRouteConst.paymentSuccessRoute);
  }

  void _handlePaymentError(
      PaymentFailureResponse response, BuildContext context) {
    try {
      GoRouter.of(context).pushNamed(MyAppRouteConst.paymentFailureRoute);
    } catch (e) {
      print("Routing error: $e");
      GoRouter.of(context).pushNamed(MyAppRouteConst.appsRoute);
    }

  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }
  openSession({
  required num amount,
  required String receiptId,
  required String key,
  Map<String, String>? prefills,
  Map<String, String>? notes,
  required BuildContext context,
}) {
  createOrder(amount: amount, receiptId: receiptId, key: key,notes:notes).then((orderId) {
    bool displayPrefills = prefills != null && prefills.isNotEmpty;
    if (orderId.toString().isNotEmpty) {
      var options = {
        'key': key, // Razorpay API Key
        'amount': amount, // Amount in the smallest currency sub-unit.
        'name': 'ProductQ',
        'order_id': orderId, // Generate order_id using Orders API
        'description':
            'Description for order', // Order Description to be shown in Razorpay page
        'timeout': 3 * 60, // Timeout in seconds
        'prefill': displayPrefills ? prefills : {},
        'notes': notes ?? {}, // Include the notes here
      };
      _razorpay.open(options);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Failed to initiate payment session")));
    }
  });
}


  createOrder({
    required num amount,
    required String receiptId,
    required String key,
    Map<String, String>? notes,
  }) async {
    print("running1");
    final myData = await getOrderId(amount, receiptId, key,notes:notes);
    if (myData["status"] == "success") {
      print(myData);
      return myData["body"]["id"];
    } else {
      return "";
    }
  }

  //generation of order id

  getOrderId(num amount, String recieptId, String key, {Map<String, String>? notes}) async {
    print("running2");
    var auth = 'Basic ${base64Encode(utf8.encode('$key:$razorPaySecret'))}';
    var headers = {'content-type': 'application/json', 'Authorization': auth};
    var request =
        http.Request('POST', Uri.parse('https://api.razorpay.com/v1/orders'));

    // Add the notes field here
    request.body = json.encode({
      "amount": amount * 100, // Amount in smallest unit like in paise for INR
      "currency": "INR", // Currency
      "receipt": recieptId, // Receipt Id
      "notes": notes ?? {}, // Custom metadata for the order
    });
    
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(await response.stream.bytesToString());
      print("Order created successfully: ${responseBody['id']}");
      return {
        "status": "success",
        "body": responseBody,
      };
    } else {
      print(
          "Error creating order: ${response.statusCode} - ${await response.stream.bytesToString()}");
      return {"status": "fail", "message": response.reasonPhrase};
    }
  }

}
