import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/models/worktool_category.dart';
import 'package:product_iq/models/worktool_skill.dart';
import 'package:product_iq/routes/app_route_consts.dart';
import 'package:product_iq/services/recently_visited_provider.dart';
import 'package:product_iq/widgets/worktools_widgets/main_card.dart';
import 'package:product_iq/widgets/common_widgets/category_chip.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'worktools_main_screen.dart';
import 'package:product_iq/widgets/common_widgets/search_widget.dart';
import 'package:http/http.dart' as http;

class WorktoolsHomeScreen extends ConsumerStatefulWidget {
  const WorktoolsHomeScreen(
      {super.key, this.initialCategory = 1, required this.appId});

  final int initialCategory;
  final int appId;

  @override
  ConsumerState<WorktoolsHomeScreen> createState() =>
      _WorktoolsHomeScreenState();
}

class _WorktoolsHomeScreenState extends ConsumerState<WorktoolsHomeScreen> {
  final List<WorktoolCategory> categories = [];
  final List<bool> isSelected = [];
  var prevSelected = 0;
  final List<WorktoolSkill> skills = [];
  final List<WorktoolSkill> filteredSkills = [];
  var isLoading = true;

  @override
  void initState() {
    prevSelected = widget.initialCategory - 1;
    loadCategories();
    loadCards(widget.initialCategory);
    super.initState();
  }

  void loadCategories() async {
    try{
    if (MyConsts.token == '') {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      setState(() {
        MyConsts.token = preferences.getString("token")!;
      });
    }
    final appsUrl = Uri.parse('${MyConsts.baseUrl}/app/${widget.appId}/categorie');
    print('baseUrl---->${MyConsts.baseUrl}/app/${widget.appId}/categorie');
print("header ${MyConsts.requestHeader}");
    http.Response response =
        await http.get(appsUrl, headers: MyConsts.requestHeader);
    print(response.body);
    var res = jsonDecode(response.body);
    if (response.statusCode == 200) {
      res = jsonDecode(response.body);
      debugPrint(res.toString());
      setState(() {
        for (var cat in res) {
          var category = WorktoolCategory.fromJson(cat);
          categories.add(category);
        }
        isSelected.addAll(List.filled(categories.length, false));
        isSelected[prevSelected] = true;
      });
    } else {
      debugPrint(response.body);
    }
    } catch (e) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     // builder: (context) => CrashErrorScreen(retry:loadCategories ),
      //   ),
      // );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    }

  void loadCards(int  categoryId) async {
    try{
    skills.clear();
    final cardsUrl =
        Uri.parse('${MyConsts.baseUrl}/app/${widget.appId}/categorie/$categoryId');
    http.Response response =
        await http.get(cardsUrl, headers: MyConsts.requestHeader);
    var res = jsonDecode(response.body);
    if (response.statusCode == 200) {
      res = jsonDecode(response.body);
      debugPrint(res.toString());
      if (res.runtimeType != List<dynamic>) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(res['message'])));

        setState(() {
          isLoading = false;
        });
        return;
      }
      for (var skill in res) {
        var worktoolSkill = WorktoolSkill.fromJson(skill);
        skills.add(worktoolSkill);
      }
      setState(() {
        filteredSkills.clear();
        filteredSkills.addAll(skills);
      });
    } else {
      debugPrint(response.body);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${res['message']}')));
    }

    setState(() {
      isLoading = false;
    });

    } catch (e) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => CrashErrorScreen(retry:(){ loadCards(widget.initialCategory); }),
      //   ),
      // );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WorktoolsMainScreen(
        title: MyConsts.productNameMap[widget.appId]!,
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: SafeArea(
            //minimum: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SearchWidget(
                    focus: false,
                    hintText: "Search Product Skills",
                    onSubmitted: (value) async {
                      filteredSkills.clear();
                      setState(() {
                        isLoading = true;
                      });
                      final searchUrl = Uri.parse(
                          '${MyConsts.baseUrl}/app/search/$value?search_lebel=categorie&depth=2');
                      http.Response response = await http.get(searchUrl,
                          headers: MyConsts.requestHeader);
                      if (response.statusCode == 200) {
                        var res = jsonDecode(response.body);
                        res = jsonDecode(response.body);
                        debugPrint(res.toString());
                        if (res['skills'] == null) {
                          setState(() {
                            isLoading = false;
                            filteredSkills.clear();
                          });
                          return;
                        }
                        //all modules which have common id in list of res and modules should be taken
                        for (var skill in skills) {
                          for (var searchSkill in res['skills']) {
                            //debugPrint(searchModule.toString());
                            if (skill.id == searchSkill['id']) {
                              filteredSkills.add(skill);
                            }
                          }
                        }
                        //debugPrint(filteredModules.toString());
                      } else {
                        setState(() {
                          filteredSkills.addAll(skills);
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
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var cat in categories)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: CategoryChip(
                                onTap: () {
                                  int ind = categories.indexOf(cat);
                                  setState(() {
                                    isLoading = true;
                                    isSelected[ind] = !isSelected[ind];
                                    isSelected[prevSelected] = false;
                                    prevSelected = ind;
                                  });
                                  loadCards(cat.id);
                                },
                                text: cat.name,
                                isSelected:
                                    isSelected[categories.indexOf(cat)]),
                          )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : filteredSkills.isEmpty
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
                                  "No Skills found",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: MyConsts.primaryDark),
                                )
                              ],
                            ),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              children: [
                                for (var skill in filteredSkills.where((skill) => skill.active))
                                  Opacity(
                                    opacity: skill.isAllowed ? 1 : 0.5,
                                    child: MainWorktoolsCard(
                                      heading: skill.name,

                                      tagText1: skill.tags[0],
                                      tagText2: skill.tags[1],
                                      subheading: skill.description,
                                      onTap: () {
                                        if (!skill.isAllowed) {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text('Skill Locked',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge!
                                                        .copyWith(
                                                            color: MyConsts
                                                                .primaryDark)),
                                                content: const Text(
                                                    'To view this skill you need to purchase the full app',
                                                    style: TextStyle(
                                                        color: MyConsts
                                                            .primaryDark)),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      GoRouter.of(context)
                                                          .goNamed(MyAppRouteConst
                                                              .subscriptionRoute);
                                                    },
                                                    child:
                                                        const Text('Buy Now'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      GoRouter.of(context)
                                                          .pop();
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
                                            .read(recentlyVisitedProvider
                                                .notifier)
                                            .addRecentlyVisited(
                                                widget.appId,
                                                skill.name,
                                                MyConsts.appTypes[1],
                                                MyAppRouteConst
                                                    .worktoolsDetailsRoute,
                                                skill.id.toString());
                                        GoRouter.of(context).pushNamed(
                                            MyAppRouteConst
                                                .worktoolsDetailsRoute,
                                            pathParameters: {
                                              'cardTitle': skill.name,
                                              'id': skill.id.toString(),
                                              'appId': widget.appId.toString()
                                            },
                                            extra: skill.questionSuggestion);
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          )
              ],
            ),
          ),
        ));
  }
}
