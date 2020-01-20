import 'package:flutter/material.dart';

class FeedFormLayout extends StatelessWidget {
  final Widget body;
  final void Function() onOK;
  final String title;
  final String buttonTitle;

  const FeedFormLayout({this.body, this.onOK, this.title, this.buttonTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: this.body,
                )
              ],
            ),
          ),
          Container(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  color: Color(0xff3bb30b),
                  textColor: Colors.white,
                  child: Text(buttonTitle),
                  onPressed: onOK,
                ),
              ))
        ]));
  }
}
