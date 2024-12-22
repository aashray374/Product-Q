import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/models/subscription.dart';
import 'package:product_iq/routes/app_route_consts.dart';
import 'package:product_iq/widgets/common_widgets/my_elevated_button.dart';
import 'package:product_iq/widgets/home_widgets/main_app_screen.dart';
import 'package:product_iq/widgets/sales_widgets/subscription_card.dart';
import 'package:product_iq/widgets/sales_widgets/toggle_chip.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/payment_service.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key, this.index});

  final int? index;

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  late TextEditingController couponController;
  int selectedWidget = 0;
  List<int> selectedSubscription = [];
  final double allAppsOriginalPrice = 2999;
  final double allAppsDiscountedPrice = 1999;
  final double secondaryAppOriginalPrice = 299;
  final double secondaryAppDiscountedPrice = 199;
  int factor = 1;
  int selectedIndex = 0;
  String selectedPack = "Monthly";
  final List<Subscription> plans = [];
  final PaymentServices _paymentServices = PaymentServices();

  double getSelectedPrice(List<int> ids) {
    double totalPrice = 0.0;

    for (var id in ids) {
      for (var plan in plans) {
        if (plan.id == id) {
          totalPrice += selectedPack == "Monthly"
              ? plan.discountedMonthly
              : plan.discountedAnnual;
        }
      }
    }

    return totalPrice;
  }

  Future<List<dynamic>> getId(bool isMonth) async {
    final paymentUrl =
    Uri.parse('${MyConsts.baseUrl}/subscription/payment-intent_razorpay');
    try {
      http.Response response = await http.post(
        paymentUrl,
        headers: MyConsts.requestHeader,
        body: jsonEncode({
          "address": {
            "line1": "123 Main St",
            "city": "Bangalore",
            "state": "Karnataka",
            "postal_code": "12345",
            "country": "US"
          },
          'duration': isMonth ? 'Monthly' : 'Four-Months',
          'plan': selectedSubscription
        }),
      );
      final res = jsonDecode(response.body);
      print(response.body);
      if (response.statusCode == 200) {
        debugPrint(res.toString());
        return [res['id'], res['key'],res['amount'],res['notes']];
      } else {
        // Return an empty list in case of error
        return [];
      }
    } catch (e) {
      print("Error fetching payment ID: $e");
      return [];
    }
  }

  @override
  void initState() {
    couponController = TextEditingController();
    _loadPlans();
    _paymentServices.intiateRazorPay(context);
    super.initState();
  }

  void _loadPlans({String? couponCode}) async {
    // Construct the URL with the coupon code as a query parameter
    Uri subscriptionUrl = Uri.parse('${MyConsts.baseUrl}/subscription/plans');
    if (couponCode != null && couponCode.isNotEmpty) {
      subscriptionUrl = subscriptionUrl.replace(queryParameters: {
        ...subscriptionUrl.queryParameters,
        'coupon': couponCode, // Add the coupon parameter
      });
    }

    if (MyConsts.token == '') {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      MyConsts.token = preferences.getString("token")!;
    }

    try {
      http.Response response =
      await http.get(subscriptionUrl, headers: MyConsts.requestHeader);
      var res = jsonDecode(response.body);

      if (response.statusCode == 200) {
        debugPrint(res.toString());
        setState(() {
          plans.clear(); // Clear existing plans
          for (var plan in res) {
            var subscriptionPlan = Subscription.fromJson(plan);
            plans.add(subscriptionPlan);
          }
        });
      } else if (res['error'] == 'Invalid Coupon') {
        // Show a toast or SnackBar for invalid coupon
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid coupon. Please try again.")),
        );
      } else {
        debugPrint(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to fetch plans")),
        );
      }
    } catch (e) {
      print("Error loading plans: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error loading plans")),
      );
    }
  }

  void _handlePlanSelection(Subscription plan) {
    setState(() {
      if (plan.name.toLowerCase() == 'all') {
        // If 'All' plan is selected, deselect all other plans
        selectedSubscription.clear();
        selectedSubscription.add(plan.id);
      } else {
        if (selectedSubscription.contains(plan.id)) {
          selectedSubscription.remove(plan.id);
        } else {
          selectedSubscription.add(plan.id);
        }

        // If all individual plans are selected, automatically select the 'All' plan
        bool allPlansSelected = plans
            .where((p) => p.name.toLowerCase() != 'all')
            .every((p) => selectedSubscription.contains(p.id));

        if (allPlansSelected) {
          selectedSubscription.clear();
          var allPlan = plans.firstWhere((p) => p.name.toLowerCase() == 'all');
          selectedSubscription.add(allPlan.id);
        } else {
          // If 'All' plan is selected and other plans are selected, deselect 'All' plan
          selectedSubscription.removeWhere((id) {
            var p = plans.firstWhere((plan) => plan.id == id);
            return p.name.toLowerCase() == 'all';
          });
        }
      }
    });
  }

  @override
  void dispose() {
    couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        GoRouter.of(context).pushReplacementNamed(MyAppRouteConst.appsRoute);
        return false;
      },
      child: MainAppScreen(
        title: MyConsts.appName,
        body: SingleChildScrollView(
          child: SafeArea(
            minimum: const EdgeInsets.all(20),
            child: Stack(
              children: [
                Column(
                  children: [
                    Text(
                      "Select Pricing",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: MyConsts.primaryDark, fontSize: 20),
                    ),
                    const SizedBox(height: 24),
                    ToggleChip(
                      onToggle: (index) {
                        setState(() {
                          selectedIndex = index!;
                          factor = index == 0 ? 1 : 12;
                          selectedPack = index == 0 ? "Monthly" : "Four-Months";
                        });
                      },
                      selectedIndex: selectedIndex,
                    ),
                    const SizedBox(height: 24),
                    Column(
                      children: plans.isEmpty
                          ? [const CircularProgressIndicator()]
                          : plans
                          .map((plan) => Padding(
                        padding:
                        const EdgeInsets.symmetric(vertical: 6),
                        child: GestureDetector(
                          onTap: () => _handlePlanSelection(plan),
                          child: SubscriptionCard(
                            cardTitle: plan.name,
                            features: plan.description
                                .split(',')
                                .map((s) => s.trim())
                                .toList(),
                            newPrice: selectedPack == "Monthly"
                                ? plan.discountedMonthly
                                : plan.discountedAnnual,
                            oldPrice: selectedPack == "Monthly"
                                ? plan.priceMonthly
                                : plan.priceAnnual,
                            isRecommended: plan.recommended,
                            bgColor: selectedSubscription
                                .contains(plan.id)
                                ? MyConsts.primaryColorTo
                                .withOpacity(0.1)
                                : Colors.white.withOpacity(0.1),
                          ),
                        ),
                      ))
                          .toList(),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: couponController,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: MyConsts.primaryDark),
                            decoration: InputDecoration(
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                  color: MyConsts.primaryDark.withOpacity(0.6), fontSize: 14),
                              hintText: "Have a Coupon Code?",
                              isDense: true,
                              contentPadding: const EdgeInsets.all(12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            if (couponController.text.isNotEmpty) {
                              _loadPlans(couponCode: couponController.text); // Fetch plans with coupon
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text("Please enter a valid coupon code")));
                            }
                          },
                          child: const Text("Apply"),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      GoRouter.of(context).pushReplacementNamed(MyAppRouteConst.appsRoute);
                    },
                    child: Text(
                      "SKIP",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(
                          color: MyConsts.primaryDark.withOpacity(0.5)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        footer: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "INR ${getSelectedPrice(selectedSubscription).toStringAsFixed(2)} / ${selectedPack == "Four-Months" ? "Yearly" : "Quarterly"}",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontSize: 16, color: MyConsts.primaryColorFrom),
                ),
                const SizedBox(height: 4),
                MyElevatedButton(
                  width: double.infinity,
                  colorFrom: MyConsts.primaryColorFrom,
                  colorTo: MyConsts.primaryColorTo,
                  child: Text(
                    "CONTINUE",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                    onTap: () async {
                    final orderDetails = await getId(selectedPack == "Monthly");
                    if (orderDetails.toString().isNotEmpty && orderDetails.length == 4) {
                      String receiptId = orderDetails[0];
                      String razorpayKey = orderDetails[1];
                      double amount = getSelectedPrice(selectedSubscription);

                      // Define notes here as a Map
                        Map<String, String> notes = (orderDetails[3] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, value.toString()));

                      _paymentServices.openSession(
                        amount: amount,
                        receiptId: receiptId,
                        key: '', //razorpayKey,
                        context: context,
                        notes: notes,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Failed to initiate payment session")));
                    }
                  },

                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
