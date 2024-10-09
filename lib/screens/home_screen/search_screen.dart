import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/routes/app_route_consts.dart';
import 'package:product_iq/widgets/common_widgets/search_widget.dart';
import 'package:product_iq/widgets/home_widgets/search_result.dart';
import 'package:http/http.dart' as http;
import 'package:product_iq/models/search_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.searchParam, this.searchResults});

  final String? searchParam;
  final Widget? searchResults;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<String> headings = [];
  final List<String> subheadings = [];
  final List<Function> funcs = [];
  final List<String> type = [];
  final List<bool> isSelected = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  bool noneSelected = true;
  bool isSearch = false;
  bool showPrevResults = false;

  @override
  void initState() {
    if (widget.searchResults != null) {
      showPrevResults = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyConsts.bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                MyConsts.searchText,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 18,
                    color: MyConsts.primaryDark,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 16,
              ),
              SearchWidget(
                searchParam: widget.searchParam,
                focus: true,
                hintText: "Ex. product",
                onSubmitted: (value) async {
                  isSearch = true;
                  showPrevResults = false;
                  headings.clear();
                  subheadings.clear();
                  funcs.clear();
                  type.clear();
                  // Implement search functionality here using the search route
                  if (MyConsts.token == '') {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    MyConsts.token = prefs.getString('token')!;
                  }
                  final searchUrl =
                      Uri.parse('${MyConsts.baseUrl}/app/search/$value');

                  http.Response response = await http.get(searchUrl,
                      headers: MyConsts.requestHeader);
                  final res = jsonDecode(response.body);
                  if (response.statusCode == 200) {
                    debugPrint(res.toString());
                    final result = SearchResult.fromJson(res);
                    for (Module module in result.modules ?? []) {
                      headings.add(module.moduleName);
                      subheadings.add(module.description);
                      type.add(MyConsts.chipsText[0]);
                      funcs.add(() {
                        GoRouter.of(context)
                            .pushNamed(MyAppRouteConst.coachModulesInfoRoute,
                                pathParameters: {
                                  'moduleTitle': module.moduleName,
                                  'id': module.id.toString(),
                                  'appId': module.appId.toString()
                                },
                                extra: 0.0);
                      });
                    }
                    for (Challenge challenge in result.challenges ?? []) {
                      headings.add(challenge.challengeName);
                      subheadings.add(challenge.moduleName);
                      type.add(MyConsts.chipsText[1]);
                      funcs.add(() {
                        GoRouter.of(context)
                            .pushNamed(MyAppRouteConst.coachModulesInfoRoute,
                                pathParameters: {
                                  'moduleTitle': challenge.moduleName,
                                  'id': challenge.module.toString(),
                                  'appId': challenge.appId.toString()
                                },
                                extra: 0.0);
                      });
                    }

                    for (Label label in result.labels ?? []) {
                      headings.add(label.labelName);
                      subheadings.add(label.levelQuestion);
                      type.add(MyConsts.chipsText[2]);
                      funcs.add(() {
                        GoRouter.of(context).pushNamed(
                            MyAppRouteConst.coachProblemRoute,
                            pathParameters: {
                              'problemTitle': label.labelName,
                              'problemId': label.id.toString(),
                              'appId': label.appId.toString()
                            },
                            extra:
                                '${label.challengeName}.\n ${label.levelQuestion}');
                      });
                    }

                    for (Category category in result.categories ?? []) {
                      headings.add(category.name);
                      subheadings.add(category.description);
                      type.add(MyConsts.chipsText[3]);
                      funcs.add(() {
                        GoRouter.of(context)
                            .pushNamed(MyAppRouteConst.worktoolsRoute,
                                extra: category.id,
                                pathParameters: {'appId': category.appId.toString()});
                      });
                    }

                    for (Skill skill in result.skills ?? []) {
                      headings.add(skill.name);
                      subheadings.add(skill.description);
                      type.add(MyConsts.chipsText[4]);
                      funcs.add(() {
                        GoRouter.of(context).pushNamed(
                            MyAppRouteConst.worktoolsDetailsRoute,
                            pathParameters: {
                              'id': skill.categorie.toString(),
                              'cardTitle': skill.name,
                              'appId': skill.appId.toString()
                            });
                      });
                    }

                    for (Section section in result.sections ?? []) {
                      headings.add(section.name);
                      subheadings.add("Product IQ");
                      type.add(MyConsts.chipsText[5]);
                      funcs.add(() {
                        GoRouter.of(context).pushNamed(MyAppRouteConst.iqRoute,
                            extra: section.id,
                            pathParameters: {'appId': section.appId.toString()});
                      });
                    }

                    for (Topic topic in result.topics ?? []) {
                      headings.add(topic.name);
                      subheadings.add(topic.sectionName);
                      type.add(MyConsts.chipsText[6]);
                      funcs.add(() {
                        GoRouter.of(context).pushNamed(
                            MyAppRouteConst.iqLearningsRoute,
                            pathParameters: {
                              'index': topic.section.toString(),
                              'title': topic.name,
                              'appId': topic.appId.toString()
                            });
                      });
                    }

                    for (Lession lession in result.lessions ?? []) {
                      headings.add(lession.name);
                      subheadings.add(lession.description);
                      type.add(MyConsts.chipsText[7]);
                      funcs.add(() {
                        GoRouter.of(context).pushNamed(
                            MyAppRouteConst.iqLearningsRoute,
                            pathParameters: {
                              'index': lession.topic.toString(),
                              'title': lession.topicName,
                              'appId': lession.appId.toString()
                            });
                      });
                    }

                    setState(() {});
                  } else {
                    debugPrint(response.body);
                  }
                },
              ),
              const SizedBox(
                height: 12,
              ),
              // Wrap(
              //   spacing: 4,
              //   runSpacing: 8,
              //   children: [
              //     for (int i = 0; i < MyConsts.chipsText.length; ++i)
              //       SearchChip(
              //         text: MyConsts.chipsText[i],
              //         isSelected: isSelected[i],
              //         onTap: () {
              //           setState(() {
              //             isSelected[i] = !isSelected[i];
              //             bool curr = false;
              //             for (var sel in isSelected) {
              //               curr |= sel;
              //             }
              //             noneSelected = !curr;
              //             // headings.clear();
              //             // subheadings.clear();
              //             // funcs.clear();
              //           });
              //         },
              //       )
              //   ],
              // ),
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  "Search Results",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 20,
                      color: MyConsts.primaryDark,
                      fontWeight: FontWeight.w500),
                ),
              ),
              showPrevResults
                  ? widget.searchResults!
                  : SearchResults(
                      title: headings,
                      subtitle: subheadings,
                      onTap: funcs,
                      type: type,
                      filters: noneSelected ? MyConsts.allTrue : isSelected,
                      isSearch: isSearch,
                    ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
