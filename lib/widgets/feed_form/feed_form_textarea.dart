import 'package:flutter/material.dart';

class FeedFormTextarea extends StatelessWidget {
  final String title;
  final TextEditingController textEditingController;

  const FeedFormTextarea({this.textEditingController, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title),
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black12,
                    border: Border.all(width: 1, color: Colors.black26),
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    textCapitalization: TextCapitalization.sentences,
                    decoration: null,
                    style: TextStyle(fontSize: 17),
                    expands: true,
                    maxLines: null,
                    controller: textEditingController,
                  ),
                ),
              ),
            ),
          )
        ]);
  }
}
