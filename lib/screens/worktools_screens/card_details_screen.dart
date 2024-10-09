import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/models/worktool_skill.dart';
import 'package:product_iq/screens/worktools_screens/worktools_main_screen.dart';
import 'package:product_iq/widgets/worktools_widgets/worktools_form.dart';
import 'package:http/http.dart' as http;

class CardDetailsScreen extends StatefulWidget {
  CardDetailsScreen(
      {super.key, required this.cardTitle, this.questions, required this.id, required this.appId});

  final String cardTitle;
  List<QuestionSuggestion>? questions;
  final String id;
  final int appId;

  @override
  State<CardDetailsScreen> createState() => _CardDetailsScreenState();
}

class _CardDetailsScreenState extends State<CardDetailsScreen> {
  var skillId = 1;
  @override
  void initState() {
    skillId = int.parse(widget.id);
    if(widget.questions == null){
      _loadQuestions(skillId);
    }
    super.initState();
  }

  void _loadQuestions(int id) async {
    // Load questions from the server
    final cardsUrl =
    Uri.parse('${MyConsts.baseUrl}/app/${widget.appId}/categorie/${id.toString()}');
    http.Response response =
    await http.get(cardsUrl, headers: MyConsts.requestHeader);
    var res = jsonDecode(response.body);
    if (response.statusCode == 200) {
      res = jsonDecode(response.body);
      debugPrint(res.toString());
      if(res.runtimeType != List<dynamic>){
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(res['message'])));
        return;
      }
      List<WorktoolSkill> skills = [];
      for(var card in res){
        var skill = WorktoolSkill.fromJson(card);
        skills.add(skill);
      }
      int selectedIndex = skills.indexWhere((element) => element.name == widget.cardTitle);
      if(selectedIndex != -1){
        setState(() {
          widget.questions = skills[selectedIndex].questionSuggestion;
          skillId = skills[selectedIndex].id;
        });
      }

    } else {
      debugPrint(response.body);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("No internet connection")));
    }
  }
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    return WorktoolsMainScreen(
        title: MyConsts.productNameMap[widget.appId]!,
        body: SingleChildScrollView(
          child: SafeArea(
            minimum: const EdgeInsets.all(20),
            child: Column(
              children: [
                Center(
                  child: Text(
                    widget.cardTitle,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: MyConsts.primaryDark),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: SvgPicture.asset(
                      "assets/elements/revenue.svg",
                      height: deviceHeight * 0.2,
                    ),
                  ),
                ),
                Text(
                  MyConsts.worktoolsRevenueText,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: MyConsts.primaryDark),
                ),
                const SizedBox(height: 24),
                if (widget.questions != null && widget.questions!.isNotEmpty)
                  WorktoolsForm(
                      title: widget.cardTitle, questions: widget.questions!, id: skillId.toString(), appId: widget.appId,),
                if(widget.questions == null)
                  const Center(child: CircularProgressIndicator())
              ],
            ),
          ),
        ));
  }
}
