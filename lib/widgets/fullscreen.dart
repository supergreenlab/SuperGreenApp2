import 'package:flutter/material.dart';

class Fullscreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const Fullscreen({@required this.title, @required this.child, this.subtitle})
      : super();

  @override
  Widget build(BuildContext context) {
    List<Widget> titles = [
      Text(
        title,
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      )
    ];
    if (subtitle != null) {
      titles.add(Text(
        subtitle,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey),
        textAlign: TextAlign.center,
      ));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
            child: Column(
          children: <Widget>[
            child,
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: titles,
                )),
          ],
        )),
      ],
    );
  }
}
