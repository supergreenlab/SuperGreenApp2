import 'package:flutter/material.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_button.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_param_layout.dart';

class YesNoFormParam extends StatelessWidget {
  final String title;
  final String icon;
  final bool yes;
  final void Function(bool) onPressed;

  const YesNoFormParam({this.icon, this.title, this.yes, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FeedFormParamLayout(
      icon: icon,
      title: title,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FeedFormButton(
                title: 'YES',
                border: yes == true,
                onPressed: () {
                  this.onPressed(yes == true ? null : true);
                },
                textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
            FeedFormButton(
                title: 'NO',
                border: yes == false,
                onPressed: () {
                  this.onPressed(yes == false ? null : false);
                },
                textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
