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

  Future<String> getUrl(bool isMonth) async {
    final paymentUrl =
    Uri.parse('${MyConsts.baseUrl}/subscription/payment-intent');
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
      return res['url'];
    } else {
      return 'https://www.google.com';
    }
  }

  @override
  void initState() {
    couponController = TextEditingController();
    _loadPlans();
    super.initState();
  }

  void _loadPlans() async {
    final subscriptionUrl = Uri.parse('${MyConsts.baseUrl}/subscription/plans');
    if (MyConsts.token == '') {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      MyConsts.token = preferences.getString("token")!;
    }
    http.Response response =
    await http.get(subscriptionUrl, headers: MyConsts.requestHeader);
    var res = jsonDecode(response.body);
    print("response of subscription ${response.body}");
    if (response.statusCode == 200) {
      debugPrint(res.toString());
      setState(() {
        for (var plan in res) {
          var subscriptionPlan = Subscription.fromJson(plan);
          plans.add(subscriptionPlan);
        }
      });
    } else {
      debugPrint(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No internet connection")));
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
    return MainAppScreen(
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
                        selectedPack =
                        index == 0 ? "Monthly" : "Four-Months";
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 6),
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
                          bgColor:
                          selectedSubscription.contains(plan.id)
                              ? MyConsts.primaryColorTo
                              .withOpacity(0.1)
                              : Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ))
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  TextField(
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
                          color: MyConsts.primaryDark.withOpacity(0.6),
                          fontSize: 14),
                      hintText: "Have a Coupon Code?",
                      isDense: true,
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    GoRouter.of(context).pop();
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
                "INR ${getSelectedPrice(selectedSubscription).toStringAsFixed(2)} / ${selectedPack == "Four-Months" ? "Yearly" : "Quaterly"}",
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
                  final url = await getUrl(selectedPack == "Monthly");
                  GoRouter.of(context).pushNamed(
                    MyAppRouteConst.paymentRoute,
                    extra: url,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
