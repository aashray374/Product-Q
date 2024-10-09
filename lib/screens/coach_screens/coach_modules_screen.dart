import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/routes/app_route_consts.dart';
import 'package:product_iq/screens/coach_screens/coach_main_screen.dart';
import 'package:product_iq/screens/crash_error_screen.dart';
import 'package:product_iq/services/recently_visited_provider.dart';
import 'package:product_iq/widgets/coach_widgets/module_widget.dart';
import 'package:product_iq/widgets/common_widgets/search_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:product_iq/models/coach_module.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CoachModulesScreen extends ConsumerStatefulWidget {
  const CoachModulesScreen({super.key, required this.appId});
  final int appId;

  @override
  ConsumerState<CoachModulesScreen> createState() => _CoachModulesScreenState();
}

class _CoachModulesScreenState extends ConsumerState<CoachModulesScreen> {
  final List<CoachModule> modules = [];
  final List<CoachModule> filteredModules = [];
  var isLoading = true;

  @override
  void initState() {
    getModules();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
/*

  void getModules() async {
    if (MyConsts.token == '') {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      setState(() {
        MyConsts.token = preferences.getString("token")!;
      });
    }
    final modulesUrl = Uri.parse('${MyConsts.baseUrl}/app/${widget.appId.toString()}/module');
    http.Response response =
        await http.get(modulesUrl, headers: MyConsts.requestHeader);
    var res = jsonDecode(response.body);
    if (response.statusCode == 200) {
      res = jsonDecode(response.body);
      debugPrint(res.toString());
      for (var module in res) {
        var coachModule = CoachModule.fromJson(module);
        modules.add(coachModule);
      }
      //sort all modules according to its order attribute
      modules.sort((a, b) => a.order.compareTo(b.order));
      setState(() {
        filteredModules.addAll(modules);
        isLoading = false;
      });
    } else {
      debugPrint(response.body);
    }
  }
*/
  void getModules() async {
    try {
      if (MyConsts.token == '') {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        setState(() {
          MyConsts.token = preferences.getString("token")!;
        });
      }
      final modulesUrl = Uri.parse('${MyConsts.baseUrl}/app/${widget.appId.toString()}/module');
      print(" getmodule----- ${MyConsts.baseUrl}/app/${widget.appId.toString()}/module");

      http.Response response = await http.get(modulesUrl, headers: MyConsts.requestHeader);
      var res = jsonDecode(response.body);
      print("getmodule----- ${response.body}");
      if (response.statusCode == 200) {
        res = jsonDecode(response.body);
        debugPrint(res.toString());
        for (var module in res) {
          var coachModule = CoachModule.fromJson(module);
          modules.add(coachModule);
        }
        // Sort all modules according to its order attribute
        modules.sort((a, b) => a.order.compareTo(b.order));
        setState(() {
          filteredModules.addAll(modules);
          isLoading = false;
        });
      } else {
        debugPrint(response.body);
        throw Exception('Failed to load modules');
      }
    } catch (e) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CrashErrorScreen(retry : getModules),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CoachMainScreen(
        appBarTitle: MyConsts.productNameMap[widget.appId]!,
        body: SingleChildScrollView(
          child: SafeArea(
            minimum: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchWidget(
                  focus: false,
                  hintText: "Product Modules",
                  onSubmitted: (value) async {
                    filteredModules.clear();
                    setState(() {
                      isLoading = true;
                    });
                    final searchUrl = Uri.parse(
                        '${MyConsts.baseUrl}/app/search/$value?search_lebel=module&depth=1');
                    http.Response response = await http.get(searchUrl,
                        headers: MyConsts.requestHeader);
                    if (response.statusCode == 200) {
                      var res = jsonDecode(response.body);
                      res = jsonDecode(response.body);
                      debugPrint(res.toString());
                      if (res['modules'] == null) {
                        setState(() {
                          isLoading = false;
                          filteredModules.clear();
                        });
                        return;
                      }
                      //all modules which have common id in list of res and modules should be taken
                      for (var module in modules) {
                        for (var searchModule in res['modules']) {
                          //debugPrint(searchModule.toString());
                          if (module.id == searchModule['id']) {
                            filteredModules.add(module);
                          }
                        }
                      }
                      //debugPrint(filteredModules.toString());
                    } else {
                      setState(() {
                        filteredModules.addAll(modules);
                      });
                      debugPrint(response.body);
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(content: Text("No internet connection")));
                    }
                    setState(() {
                      isLoading = false;
                    });
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  "Product Modules",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontSize: 18, color: MyConsts.primaryDark),
                ),
                const SizedBox(
                  height: 12,
                ),
                isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(48.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : filteredModules.isEmpty
                        ? Opacity(
                            opacity: 0.6,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Center(
                                    child: SvgPicture.asset(
                                  'assets/elements/no-results.svg',
                                  height: 240,
                                )),
                                const SizedBox(height: 12),
                                Text(
                                  "No modules found",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: MyConsts.primaryDark),
                                ),
                              ],
                            ),
                          )
                        : GridView(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 1.12,
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12),
                            children : [
                              for (var module in filteredModules)
                                GestureDetector(
                                  onTap: () {
                                    if (!module.isAllowed) {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('Module Locked',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge!
                                                    .copyWith(
                                                        color: MyConsts
                                                            .primaryDark)),
                                            content: const Text(
                                                'To view this module you need to purchase the full app', style: TextStyle(color: MyConsts.primaryDark)),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  GoRouter.of(context).goNamed(
                                                      MyAppRouteConst
                                                          .subscriptionRoute);
                                                },
                                                child: const Text('Buy Now'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  GoRouter.of(context).pop();
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      return;
                                    }
                                    ref
                                        .read(recentlyVisitedProvider.notifier)
                                        .addRecentlyVisited(
                                          widget.appId,
                                          module.moduleName,
                                          MyConsts.appTypes[0],
                                          MyAppRouteConst.coachModulesInfoRoute,
                                          module.id.toString(),
                                          coachPercent: module.totalPercent == 0
                                              ? 0.0
                                              : module.completedPercent /
                                                  module.totalPercent,
                                      completedPercent: module.completedPercent.toString(),
                                      totalPercent: module.totalPercent.toString(),
                                        );

                                    GoRouter.of(context).pushNamed(
                                        MyAppRouteConst.coachModulesInfoRoute,
                                        extra: module.totalPercent == 0
                                            ? 0.0
                                            : module.completedPercent /
                                                module.totalPercent,
                                        pathParameters: {
                                          'appId': widget.appId.toString(),
                                          'moduleTitle': module.moduleName,
                                          'id': module.id.toString(),
                                          'completedPercent': module.completedPercent.toString(),
                                          'totalPercent': module.totalPercent.toString(),
                                        });
                                  },
                                  child: Opacity(
                                    opacity: module.isAllowed ? 1.0 : 0.5,
                                    child: ModuleWidget(
                                      appTitle: MyConsts.productNameMap[widget.appId],
                                      title: module.moduleName,
                                      percentCompleted: module.totalPercent == 0
                                          ? 0.0
                                          : module.completedPercent /
                                              module.totalPercent,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                const SizedBox(
                  height: 80,
                )
              ],
            ),
          ),
        ));
  }
}
