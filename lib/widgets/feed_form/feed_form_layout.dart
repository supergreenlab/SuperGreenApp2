import 'package:flutter/material.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/green_button.dart';

class FeedFormLayout extends StatelessWidget {
  final Widget body;
  final void Function() onOK;
  final String title;
  final String buttonTitle;

  const FeedFormLayout(
      {@required this.body,
      @required this.onOK,
      @required this.title,
      @required this.buttonTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SGLAppBar(title),
        body: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 24.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: this.body),
                  Container(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GreenButton(
                          title: buttonTitle,
                          onPressed: onOK,
                        ),
                      ))
                ])));
  }
}
