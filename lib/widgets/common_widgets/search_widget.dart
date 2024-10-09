
import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';


class SearchWidget extends StatefulWidget {
  SearchWidget({super.key, required this.focus, required this.hintText, this.onSubmitted, this.searchParam});

  var focus;
  final String hintText;
  void Function(String)? onSubmitted;
  final String? searchParam;

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  late TextEditingController _searchController;
  final focusNode = FocusNode();
  final _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  var micIcon = Icons.mic;

  @override
  void initState() {
    _searchController = TextEditingController();
    if (widget.searchParam != null) {
      _searchController.text = widget.searchParam!;
      //submit the form
      widget.onSubmitted!(widget.searchParam!);
    }
    if (!focusNode.hasFocus && widget.focus) {
      focusNode.requestFocus();
      widget.focus = false;
      //focusOnNextUnfocus = false; // Reset to false once it has been processed
    }
    _initSpeech();
    super.initState();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize(debugLogging: true);
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult, listenFor: const Duration(seconds: 30));
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      _searchController.text = _lastWords;
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      focusNode: focusNode,
      controller: _searchController,
      leading: const Icon(Icons.search),
      trailing: [IconButton(icon: const Icon(Icons.mic), onPressed: (){
        if (_speechEnabled) {
          _speechToText.isListening ? _stopListening() : _startListening();
        }
      },)],
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      surfaceTintColor: MaterialStateProperty.all(Colors.white),
      shadowColor: MaterialStateProperty.all(Colors.white),
      hintText: widget.hintText,
      hintStyle: MaterialStateProperty.all(Theme.of(context)
          .textTheme
          .bodyMedium!
          .copyWith(
              color: MyConsts.primaryDark.withOpacity(0.6),
              fontSize: 14,
              fontWeight: FontWeight.w600)),
      textStyle: MaterialStateProperty.all(Theme.of(context)
          .textTheme
          .bodyMedium!
          .copyWith(color: MyConsts.primaryDark)),
      onSubmitted: widget.onSubmitted,
    );
  }
}
