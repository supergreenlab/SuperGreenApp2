import 'package:flutter/material.dart';

class FeedFormTextarea extends StatelessWidget {
  final TextEditingController textEditingController;

  const FeedFormTextarea({this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.black26),
            borderRadius: BorderRadius.circular(3)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            textCapitalization: TextCapitalization.sentences,
            decoration: null,
            style: TextStyle(fontSize: 15),
            expands: true,
            maxLines: null,
            controller: textEditingController,
          ),
        ),
      ),
    );
  }
}
