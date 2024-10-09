import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/models/purchases.dart';
import 'package:product_iq/widgets/home_widgets/main_app_screen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PurchasesScreen extends StatefulWidget {
  const PurchasesScreen({super.key});

  @override
  State<PurchasesScreen> createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends State<PurchasesScreen> {
  final List<Purchases> subscriptions = [];
  var isLoading = true;

  @override
  void initState() {
    _loadSubscriptions();
    super.initState();
  }

  DateTime calculatePlanExpiry(DateTime purchaseDate, bool isMonthly) {
    if (isMonthly) {
      return purchaseDate.add(const Duration(days: 30));
    } else {
      return purchaseDate.add(const Duration(days: 365));
    }
  }

  void _loadSubscriptions() async {
    debugPrint("Loading subscriptions");
    final subscriptionUrl = Uri.parse('${MyConsts.baseUrl}/subscription/my');
    http.Response response =
        await http.get(subscriptionUrl, headers: MyConsts.requestHeader);
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      debugPrint(res.toString());
      for (var purchase in res) {
        subscriptions.add(Purchases.fromJson(purchase));
      }
      //sort base on start date
      subscriptions.sort((a, b) => b.startDate.compareTo(a.startDate));
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainAppScreen(
        title: "My Subscriptions",
        body: SafeArea(
          minimum: const EdgeInsets.all(20),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : subscriptions.isEmpty
                  ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                              child: SvgPicture.asset(
                            'assets/elements/empty-plant.svg',
                            height: 240,
                          )),
                          Text(
                            "Purchase a plan to view your subscriptions",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: MyConsts.primaryDark.withOpacity(0.5)),
                          ),
                          const SizedBox(
                            height: 32,
                          )
                        ],
                      ),
                  )
                  : ListView.builder(
                      itemCount: subscriptions.length,
                      shrinkWrap: false,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: MyConsts.primaryColorTo
                                          .withOpacity(0.1),
                                    ),
                                    child: const Icon(
                                      Icons.credit_card,
                                      color: MyConsts.primaryColorTo,
                                      size: 20,
                                    ),
                                  ),
                                  title: Text(
                                    subscriptions[index].plan,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: MyConsts.primaryDark,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(
                                      DateFormat('dd-MM-yyyy').format(
                                          subscriptions[index].startDate),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              fontSize: 14,
                                              color: MyConsts.primaryDark
                                                  .withOpacity(0.7))),
                                  trailing: Text(
                                    '₹ ${subscriptions[index].amountPaid.toString()}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            color: MyConsts.primaryColorFrom,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                  ),
                                  tileColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 24.0),
                                  child: Divider(),
                                ),
                                Text(
                                    "Expires on ${DateFormat('dd-MM-yyyy').format(calculatePlanExpiry(subscriptions[index].startDate, subscriptions[index].plan == "Monthly"))}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            fontSize: 14,
                                            color: MyConsts.primaryDark
                                                .withOpacity(0.7))),
                                const SizedBox(
                                  height: 8,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ));
  }
}
