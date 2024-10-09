import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/routes/app_route_consts.dart';
import 'package:product_iq/screens/crash_error_screen.dart';
import 'package:product_iq/services/recently_visited_provider.dart';
import 'package:product_iq/widgets/common_widgets/my_list_tile.dart';
import 'package:product_iq/widgets/home_widgets/start_learning_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_iq/widgets/home_widgets/story_shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Future<void> _recentlyVisitedFuture;
  final List<String> headings = [];
  final List<String> body = [];
  final List<String> buttonText = [];
  final List<void Function()> buttonOnTap = [];
  final List<String> appName = [];
  var isCoachSubscribed = false;
  var isWorktoolsSubscribed = false;
  var isIQSubscribed = false;

  @override
  void initState() {
    _recentlyVisitedFuture =
        ref.read(recentlyVisitedProvider.notifier).loadRecentlyVisited();
    _loadTrending();
    super.initState();
  }

  Future<void> _getSubscriptions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    MyConsts.token = prefs.getString('token')!;
    debugPrint(MyConsts.token);
    MyConsts.requestHeader['Authorization'] = 'bearer ${MyConsts.token}';
    final subscriptionUrl = Uri.parse('${MyConsts.baseUrl}/app/all');
    var t = JwtDecoder.getExpirationDate(MyConsts.token);
    debugPrint(t.toString());
    http.Response response =
        await http.get(subscriptionUrl, headers: MyConsts.requestHeader);
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      debugPrint(res.toString());
      int ind=0;
      for(var app in res) {
        MyConsts.productNameMap[app['id']] = app['app_name'];
        if(ind<MyConsts.productName.length) {
          MyConsts.productName[ind] = app['app_name'];
        }
        else{
          MyConsts.productName.add(app['app_name']);
        }
        if (app['is_subscribed'] == true) {
          if (app['app_type'] == 'modules') {
            isCoachSubscribed = true;
          }
          if (app['app_type'] == 'worktools') {
            isWorktoolsSubscribed = true;
          }
          if (app['app_type'] == 'productiq') {
            isIQSubscribed = true;
          }
        }
      }
      if (isCoachSubscribed && isWorktoolsSubscribed && isIQSubscribed) {
        MyConsts.isSubscribed = true;
      } else {
        MyConsts.isSubscribed = false;
      }
    } else {
      debugPrint(response.body);
      debugPrint(MyConsts.token);
    }
  }
  void _loadTrending() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      MyConsts.token = prefs.getString('token')!;
      await _getSubscriptions();
      final trendingModulesUrl = Uri.parse('${MyConsts.baseUrl}/app/trending/modules');
      final trendingWorktoolsUrl = Uri.parse('${MyConsts.baseUrl}/app/trending/worktools');

      http.Response modulesResponse = await http.get(trendingModulesUrl, headers: MyConsts.requestHeader);
      if (modulesResponse.statusCode == 200) {
        final res = jsonDecode(modulesResponse.body);
        debugPrint(res.toString());
        for (var item in res['modules']) {
          for (var challenge in item['challenges']) {
            headings.add('New in ${MyConsts.productNameMap[challenge['app_id']]}!!');
            debugPrint(challenge['challenge_name']);
            String bodyText = 'Challenge @ ${item['module_name']}';
            bodyText = bodyText + '\n' + challenge['challenge_name'];
            body.add(bodyText);
            if (isCoachSubscribed) {
              buttonText.add('Answer Now');
              buttonOnTap.add(() {
                debugPrint(item['module_name']);
                GoRouter.of(context).pushNamed(
                    MyAppRouteConst.coachModulesInfoRoute,
                    pathParameters: {
                      'moduleTitle': item['module_name'],
                      'id': item['module_id'].toString(),
                      'appId': challenge['app_id'].toString()
                    },
                    extra: 0.0);
              });
            } else {
              buttonText.add('Subscribe Now');
              buttonOnTap.add(() {
                GoRouter.of(context).pushNamed(MyAppRouteConst.subscriptionRoute, extra: 0);
              });
            }
            appName.add(MyConsts.productName[0]);
          }
        }
      } else {
        debugPrint(modulesResponse.body);
        throw Exception('Failed to load trending modules');
      }

      http.Response worktoolsResponse = await http.get(trendingWorktoolsUrl, headers: MyConsts.requestHeader);
      if (worktoolsResponse.statusCode == 200) {
        final res = jsonDecode(worktoolsResponse.body);
        debugPrint(res.toString());
        for (var item in res['category']) {
          for (var skill in item['skills']) {
            headings.add('New in ${MyConsts.productNameMap[skill['app_id']]}!!');
            body.add('${skill['skill_name']} @ ${item['category_name']}');
            if (isWorktoolsSubscribed) {
              buttonText.add('Generate Now');
              buttonOnTap.add(() {
                debugPrint(skill['skill_name']);
                GoRouter.of(context).pushNamed(
                    MyAppRouteConst.worktoolsDetailsRoute,
                    pathParameters: {
                      'cardTitle': skill['skill_name'],
                      'id': skill['skill_id'].toString(),
                      'appId': skill['app_id']
                    });
              });
            } else {
              buttonText.add('Subscribe Now');
              buttonOnTap.add(() {
                GoRouter.of(context).pushNamed(MyAppRouteConst.subscriptionRoute, extra: 1);
              });
            }
            appName.add(MyConsts.productName[1]);
          }
        }
        setState(() {});
      } else {
        debugPrint(worktoolsResponse.body);
        throw Exception('Failed to load trending worktools');
      }
    } catch (e) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CrashErrorScreen(retry: _loadTrending),
        ),
      );
    }
  }

/*

  void _loadTrending() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    MyConsts.token = prefs.getString('token')!;
    await _getSubscriptions();
    final trendingModulesUrl =
        Uri.parse('${MyConsts.baseUrl}/app/trending/modules');
    final trendingWorktoolsUrl =
        Uri.parse('${MyConsts.baseUrl}/app/trending/worktools');

    http.Response modulesResponse =
        await http.get(trendingModulesUrl, headers: MyConsts.requestHeader);
    if (modulesResponse.statusCode == 200) {
      final res = jsonDecode(modulesResponse.body);
      debugPrint(res.toString());
      for (var item in res['modules']) {
        for(var challenge in item['challenges']){
        headings.add('New in ${MyConsts.productNameMap[challenge['app_id']]}!!');
          debugPrint(challenge['challenge_name']);
          String bodyText = 'Challenge @ ${item['module_name']}';
          bodyText = bodyText + '\n' + challenge['challenge_name'];
          body.add(bodyText);
        if (isCoachSubscribed) {
          buttonText.add('Answer Now');
          buttonOnTap.add(() {
            debugPrint(item['module_name']);
            GoRouter.of(context).pushNamed(
                MyAppRouteConst.coachModulesInfoRoute,
                pathParameters: {
                  'moduleTitle': item['module_name'],
                  'id': item['module_id'].toString(),
                  'appId': challenge['app_id'].toString()
                },
                extra: 0.0);
          });
        } else {
          buttonText.add('Subscribe Now');
          buttonOnTap.add(() {
            GoRouter.of(context)
                .pushNamed(MyAppRouteConst.subscriptionRoute, extra: 0);
          });
        }
        appName.add(MyConsts.productName[0]);
      }}
      //setState(() {});
    }
    http.Response worktoolsResponse =
        await http.get(trendingWorktoolsUrl, headers: MyConsts.requestHeader);
    if (worktoolsResponse.statusCode == 200) {
      final res = jsonDecode(worktoolsResponse.body);
      debugPrint(res.toString());
      for (var item in res['category']) {
        for (var skill in item['skills']) {
          headings.add('New in ${MyConsts.productNameMap[skill['app_id']]}!!');
          body.add('${skill['skill_name']} @ ${item['category_name']}');
          if (isWorktoolsSubscribed) {
            buttonText.add('Generate Now');
            buttonOnTap.add(() {
              debugPrint(skill['skill_name']);
              GoRouter.of(context).pushNamed(
                  MyAppRouteConst.worktoolsDetailsRoute,
                  pathParameters: {
                    'cardTitle': skill['skill_name'],
                    'id': skill['skill_id'].toString(),
                    'appId': skill['app_id']
                  });
            });
          } else {
            buttonText.add('Subscribe Now');
            buttonOnTap.add(() {
              GoRouter.of(context)
                  .pushNamed(MyAppRouteConst.subscriptionRoute, extra: 1);
            });
          }
          appName.add(MyConsts.productName[1]);
        }
      }
      setState(() {});
    }
  }
*/

  @override
  Widget build(BuildContext context) {
    final _recentlyVisited = ref.watch(recentlyVisitedProvider);
    return SafeArea(
      minimum: const EdgeInsets.only(left: 20, top: 72),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                MyConsts.appName,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: MyConsts.primaryColorTo,
                    fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: StartLearningWidget(),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                const Icon(Icons.trending_up),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  "Trending Topics",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 20,
                      color: MyConsts.primaryDark,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            headings.isEmpty
                ? const StoryShimmer()
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int i = 0; i < 7; ++i)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 12),
                            child: GestureDetector(
                              onTap: () {
                                GoRouter.of(context).pushNamed(
                                    MyAppRouteConst.trendingRoute,
                                    extra: {
                                      'headings': headings,
                                      'body': body,
                                      'buttonText': buttonText,
                                      'onTap': buttonOnTap,
                                      'appName': appName
                                    });
                              },
                              child: const CircleAvatar(
                                radius: 28,
                                backgroundColor: MyConsts.primaryColorFrom,
                                child: CircleAvatar(
                                  radius: 26,
                                  backgroundColor: MyConsts.bgColor,
                                  child: CircleAvatar(
                                      radius: 24,
                                      backgroundImage: AssetImage(
                                          'assets/elements/story-bg.png')),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
            //
            const SizedBox(
              height: 24,
            ),
            Row(
              children: [
                const Icon(Icons.access_time_outlined),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  "Recently Visited",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 20,
                      color: MyConsts.primaryDark,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(
              height: 4,
            ),/*
        FutureBuilder(
          future: _recentlyVisitedFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'An error occurred: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.red,
                  ),
                ),
              );
            }
            if (!snapshot.hasData || _recentlyVisited.isEmpty) {
              return Column(
                children: [
                  Center(
                    child: SvgPicture.asset(
                      'assets/elements/empty-plant.svg',
                      height: 240,
                    ),
                  ),
                  Text(
                    "Start exploring to see\nyour recently visited items.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: MyConsts.primaryDark.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  )
                ],
              );
            }
            return Column(
              children: [
                for (var item in _recentlyVisited)
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0, top: 12),
                    child: GestureDetector(
                      onTap: () {
                        debugPrint(item.coachPercent.toString());
                        if (item.appType == MyConsts.appTypes[0]) {
                          GoRouter.of(context).pushNamed(item.appRoute,
                              extra: item.coachPercent ?? 0.0,
                              pathParameters: {
                                'moduleTitle': item.title,
                                'id': item.typeId.toString(),
                                'appId': item.appId.toString()
                              });
                        } else if (item.appType == MyConsts.appTypes[1]) {
                          GoRouter.of(context).pushNamed(item.appRoute,
                              pathParameters: {
                                'cardTitle': item.title,
                                'id': item.typeId.toString(),
                                'appId': item.appId.toString()
                              });
                        } else {
                          GoRouter.of(context).pushNamed(item.appRoute,
                              pathParameters: {
                                'title': item.title,
                                'id': item.typeId.toString(),
                                'appId': item.appId.toString()
                              });
                        }
                      },
                      child: MyListTile(
                        title: item.title,
                        subtitle: MyConsts.productNameMap[item.appId]!,
                        iconColor: item.appType == MyConsts.appTypes[0]
                            ? MyConsts.productColors[0][1]
                            : item.appType == MyConsts.appTypes[1]
                            ? MyConsts.productColors[1][1]
                            : MyConsts.productColors[2][1],
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 24,
                ),
              ],
            );
          },
        ),*/

        FutureBuilder(
                future: _recentlyVisitedFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (_recentlyVisited.isEmpty) {
                    return Column(
                      children: [
                        Center(
                            child: SvgPicture.asset(
                          'assets/elements/empty-plant.svg',
                          height: 240,
                        )),
                        Text(
                          "Start exploring to see\nyour recently visited items.",
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
                    );
                  }
                  return Column(
                    children: [
                      for (var item in _recentlyVisited)
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0, top: 12),
                          child: GestureDetector(
                            onTap: () {
                              debugPrint(item.coachPercent.toString());
                              if (item.appType == MyConsts.appTypes[0]) {
                                GoRouter.of(context).pushNamed(
                                    item.appRoute,
                                    extra: item.coachPercent ?? 0.0,
                                    pathParameters: {
                                      'completedPercent':item.completedPercent.toString(),
                                      'totalPercent':item.totalPercent.toString(),
                                      'moduleTitle': item.title,
                                      'id': item.typeId.toString(),
                                      'appId': item.appId.toString()
                                    });
                              } else if (item.appType ==
                                  MyConsts.appTypes[1]) {
                                GoRouter.of(context).pushNamed(item.appRoute,
                                    pathParameters: {
                                      'cardTitle': item.title,
                                      'id': item.typeId.toString(),
                                      'appId': item.appId.toString()
                                    });
                              } else {
                                GoRouter.of(context).pushNamed(item.appRoute,
                                    pathParameters: {
                                      'title': item.title,
                                      'id': item.typeId.toString(),
                                      'appId': item.appId.toString()
                                    });
                              }
                            },
                            child: MyListTile(
                              title: item.title,
                              subtitle: MyConsts.productNameMap[item.appId]!,
                              iconColor: item.appType == MyConsts.appTypes[0]
                                  ? MyConsts.productColors[0][1]
                                  : item.appType == MyConsts.appTypes[1]
                                      ? MyConsts.productColors[1][1]
                                      : MyConsts.productColors[2][1],
                            ),
                          ),
                        ),
                      const SizedBox(
                        height: 24,
                      ),
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }
}
