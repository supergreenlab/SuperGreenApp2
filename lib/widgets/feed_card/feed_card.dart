import 'package:flutter/material.dart';

class FeedCard extends StatelessWidget {
  final Widget child;

  const FeedCard({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.yellow, width: 3),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(4, 4))],
              color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: child),
    );
  }
}
