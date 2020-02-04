import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FeedFormParamLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final String icon;

  FeedFormParamLayout(
      {@required this.child, @required this.icon, @required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          color: Color(0xFFECECEC),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              _renderIcon(),
              Text(
                this.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ]),
          ),
        ),
        this.child,
      ],
    );
  }

  Widget _renderIcon() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(25))),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: SvgPicture.asset(this.icon),
        ),
      ),
    );
  }
}
