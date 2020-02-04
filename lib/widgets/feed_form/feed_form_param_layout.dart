import 'package:flutter/material.dart';
import 'package:super_green_app/widgets/section_title.dart';

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
        SectionTitle(title: title, icon: icon),
        this.child,
      ],
    );
  }


}
