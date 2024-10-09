import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/models/worktool_skill.dart';
import 'package:product_iq/models/worktools_result.dart';
import 'package:product_iq/routes/app_route_consts.dart';
import 'package:product_iq/widgets/common_widgets/my_elevated_button.dart';
import 'package:product_iq/widgets/worktools_widgets/text_input.dart';
import 'package:http/http.dart' as http;

class WorktoolsForm extends StatefulWidget {
  const WorktoolsForm(
      {super.key,
      required this.title,
      required this.questions,
      required this.id, required this.appId});

  final String title;
  final List<QuestionSuggestion> questions;
  final String id;
  final int appId;

  @override
  State<WorktoolsForm> createState() => _WorktoolsFormState();
}

class _WorktoolsFormState extends State<WorktoolsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> enteredText = ['', '', '', '', '', '', ''];
  var isLoading = false;

  void saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var submitUrl =
          Uri.parse('${MyConsts.baseUrl}/app/${widget.appId}/response/skill/${widget.id}');
      //map the questions and answers in the body
      Map<String, Map<String, String>> body = {'answer': {}};
      for (var i = 0; i < widget.questions.length; i++) {
        body['answer']?[widget.questions[i].name] = enteredText[i];
      }
      debugPrint(json.encode(body));
      http.Response response = await http.post(submitUrl,
          headers: MyConsts.requestHeader, body: json.encode(body));
      final res = jsonDecode(response.body);
      if (response.statusCode == 200) {
        debugPrint(res.toString());
        final result = WorktoolsResult.fromJson(res['result']);
        isLoading = false;

        GoRouter.of(context).pushNamed(
            MyAppRouteConst.worktoolsSkillGapAnalysisRoute,
            pathParameters: {'title': widget.title},
            extra: result);
      }
      else if(response.statusCode == 500){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['error'])));
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var ques in widget.questions)
              TextInput(
                title: ques.name,
                hintText: ques.placeholder,
                onSaved: (txt) {
                  enteredText[widget.questions.indexOf(ques)] = txt!;
                },
              ),
            const SizedBox(
              height: 12,
            ),
            MyElevatedButton(
              width: double.infinity,
              colorFrom: MyConsts.productColors[1][0],
              colorTo: MyConsts.productColors[1][1],
              onTap: () {
                setState(() {
                  isLoading = true;
                });
                saveForm();
              },
              child: isLoading
                  ? const CircularProgressIndicator(color: MyConsts.bgColor,)
                  : Text(
                      "Explore ${widget.title}",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontSize: 14),
                    ),
            )
          ],
        ));
  }
}
