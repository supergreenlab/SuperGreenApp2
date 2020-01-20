import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FeedFormParamLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final String icon;

  FeedFormParamLayout({this.child, this.icon, this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _renderIcon(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                this.title,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
              Container(child: this.child),
            ],
          ),
        )
      ]),
    );
  }

  Widget _renderIcon() {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
          child: SvgPicture.asset(this.icon),
        ),
      ),
    );
  }
}
