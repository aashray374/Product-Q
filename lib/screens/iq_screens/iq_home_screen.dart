import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:product_iq/models/iq_section.dart';
import 'package:product_iq/screens/iq_screens/main_iq_screen.dart';
import 'package:product_iq/widgets/common_widgets/category_chip.dart';
import 'package:product_iq/widgets/common_widgets/search_widget.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/widgets/iq_widgets/main_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class IQHomeScreen extends StatefulWidget {
  const IQHomeScreen({super.key, this.initialSection = 1, required this.appId});

  final int initialSection;
  final int appId;

  @override
  State<IQHomeScreen> createState() => _IQHomeScreenState();
}

class _IQHomeScreenState extends State<IQHomeScreen> {
  final List<IqSection> sections = [];
  final List<IqSection> selectedTopics = [];
  final List<IqSection> filteredTopics = [];
  var isLoading = true;
  final List<bool> isSelected = [];
  var prevSelected = 0;

  @override
  void initState() {
    prevSelected = widget.initialSection - 1;
    loadSections();
    super.initState();
  }

  void loadSections() async {
    if (MyConsts.token == '') {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      setState(() {
        MyConsts.token = preferences.getString("token")!;
      });
    }

    final appsUrl = Uri.parse('${MyConsts.baseUrl}/app/${widget.appId}/section/topics');
    http.Response response =
        await http.get(appsUrl, headers: MyConsts.requestHeader);
    var res = jsonDecode(response.body);
    if (response.statusCode == 200) {
      res = jsonDecode(response.body);
      debugPrint(res.toString());
      setState(() {
        for (var sec in res) {
          var iqSection = IqSection.fromJson(sec);
          sections.add(iqSection);
        }
        isSelected.addAll(List.filled(sections.length, false));
        isSelected[widget.initialSection - 1] = true;
        filteredTopics.addAll(sections[widget.initialSection - 1].topic ?? []);
        isLoading = false;
      });
    } else {
      debugPrint(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainIQScreen(
      appId: widget.appId,
        body: SingleChildScrollView(
      child: SafeArea(
        //minimum: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.all(20),
                child: SearchWidget(
                  focus: false,
                  hintText: "Search Product Topics",
                  onSubmitted: (value) async {
                    filteredTopics.clear();
                    setState(() {
                      isLoading = true;
                    });
                    final searchUrl = Uri.parse(
                        '${MyConsts.baseUrl}/app/search/$value?search_lebel=section&depth=2');
                    http.Response response = await http.get(searchUrl,
                        headers: MyConsts.requestHeader);
                    if (response.statusCode == 200) {
                      var res = jsonDecode(response.body);
                      res = jsonDecode(response.body);
                      debugPrint(res.toString());
                      if (res['topics'] == null) {
                        setState(() {
                          isLoading = false;
                          filteredTopics.clear();
                        });
                        return;
                      }
                      //all modules which have common id in list of res and modules should be taken
                      for (var topic in sections[prevSelected].topic ?? []) {
                        for (var searchTopic in res['topics']) {
                          //debugPrint(searchModule.toString());
                          if (topic.id == searchTopic['id']) {
                            filteredTopics.add(topic);
                          }
                        }
                      }
                      //debugPrint(filteredModules.toString());
                    } else {
                      setState(() {
                        filteredTopics.addAll(selectedTopics);
                      });
                      debugPrint(response.body);
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(content: Text("No internet connection")));
                    }
                    setState(() {
                      isLoading = false;
                    });
                  },
                )),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var sec in sections)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: CategoryChip(
                            colorFrom: MyConsts.productColors[2][0],
                            colorTo: MyConsts.productColors[2][1],
                            onTap: () {
                              int ind = sections.indexOf(sec);
                              setState(() {
                                //isLoading = true;
                                isSelected[ind] = !isSelected[ind];
                                isSelected[prevSelected] = false;
                                prevSelected = ind;
                                filteredTopics.clear();
                                filteredTopics.addAll(sections[ind].topic ?? []);
                              });
                            },
                            text: sec.name,
                            isSelected: isSelected[sections.indexOf(sec)]),
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
                : filteredTopics.isEmpty ? Opacity(
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
                    "No topics found",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: MyConsts.primaryDark),
                  )
                ],
              ),
            ) : Column(
                    children: [
                      for (var topic in filteredTopics)
                        Opacity(
                          opacity: topic.isAllowed ? 1 : 0.5,
                          child: MainIQCard(
                            appId: widget.appId,
                            icon: Icons.sell,
                            text: topic.name,
                            index:  topic.id,
                            isAllowed: topic.isAllowed,
                          ),
                        ),
                    ],
                  )
          ],
        ),
      ),
    ));
  }
}
