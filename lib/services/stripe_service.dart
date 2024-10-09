// import 'dart:convert';
//
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:product_iq/consts.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
//
// class StripeService {
//   static var res;
//   Future<void> initPaymentSheet(BuildContext context) async {
//     // final paymentSheet = PaymentSheetTest();
//     // await paymentSheet.initPaymentSheet();
//     try {
//       final paymentUrl = Uri.parse(
//           '${MyConsts.baseUrl}/subscription/payment-intent/plan/1/duration/Monthly');
//       http.Response response = await http.post(
//         paymentUrl,
//         headers: MyConsts.requestHeader,
//       );
//       res = jsonDecode(response.body);
//       if (response.statusCode == 200) {
//         debugPrint(res.toString());
//         final ephemeralKey = res['ephemeral_key']['secret'];
//         final clientSecret = res['payment_intent']['client_secret'];
//         final id = res['payment_intent']['id'];
//         BillingDetails billingDetails = BillingDetails(
//
//           address: Address(
//             city: 'Banglore',
//             country: 'India',
//             line1: '',
//             line2: '',
//             postalCode: '00100',
//             state: 'Karnataka',
//           ),);
//         Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;
//         await Stripe.instance.initPaymentSheet(
//             paymentSheetParameters: SetupPaymentSheetParameters(
//            //   billingDetails: billingDetails,
//           customFlow: false,
//           paymentIntentClientSecret: clientSecret,
//           customerEphemeralKeySecret: ephemeralKey,
//           customerId: id,
//           merchantDisplayName: 'Product Cohort',
//           style: ThemeMode.light,
//           googlePay: const PaymentSheetGooglePay(
//               merchantCountryCode: 'IN', currencyCode: 'inr', testEnv: true),
//         ));
//
//         debugPrint('1');
//
//         displayPaymentSheet();
//
//         debugPrint('2');
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error initializing payment: $e')),
//       );
//       debugPrint(e.toString());
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(e.toString())),
//       );
//     }
//   }
//
//   displayPaymentSheet() async{
//     try {
//       await Stripe.instance.presentPaymentSheet().then((value) {
//
//         //Clear paymentIntent variable after successful payment
//         res = null;
//
//       })
//           .onError((error, stackTrace) {
//         throw Exception(error);
//       });
//     }
//     on StripeException catch (e) {
//       debugPrint('Error is:---> $e');
//     }
//     catch (e) {
//       debugPrint('$e');
//     }
//   }
//
//
//
//
//
//
//
//
//   // String secretKey = dotenv.env['STRIPE_SECRET_KEY']!;
//   // String publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;
//
//   //static Future<dynamic> createCheckoutSession(){}
// }
