import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/models/learning.dart';
import 'package:product_iq/screens/iq_screens/main_learning_screen.dart';
import 'package:product_iq/widgets/iq_widgets/learnings_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LearningsScreen extends StatefulWidget {
  const LearningsScreen({super.key, required this.title, required this.index, required this.appId});

  final String title;
  final String index;
  final int appId;

  @override
  State<LearningsScreen> createState() => _LearningsScreenState();
}

class _LearningsScreenState extends State<LearningsScreen> {
  final List<Learning> learnings = [];
  var isLoading = true;

  @override
  void initState() {
    _loadLearnings(widget.index);
    super.initState();
  }

  void _loadLearnings(String id) async {
    final learningsUrl =
        Uri.parse('${MyConsts.baseUrl}/app/${widget.appId}/section/topics/$id/lessions');
    if (MyConsts.token == '') {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      MyConsts.token = preferences.getString("token")!;
    }
    http.Response response =
        await http.get(learningsUrl, headers: MyConsts.requestHeader);
    final res = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (res.runtimeType == List) {
        for (var learning in res) {
          learnings.add(Learning.fromJson(learning));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('No Learnings Found')));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: ${response.body}')));
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainLearningScreen(
      appId: widget.appId,
      title: widget.title,
      body: isLoading
          ? [const Center(child: CircularProgressIndicator())]
          : [
              for (var learning in learnings)
                LearningsCard(
                  appId: widget.appId,
                  learnings: learnings,
                  index: learnings.indexOf(learning),
                  showFullText: true,
                ),
            ],
    );
  }
}
