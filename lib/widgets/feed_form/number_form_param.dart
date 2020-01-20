import 'package:flutter/material.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_button.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_param_layout.dart';

class NumberFormParam extends StatelessWidget {
  final String title;
  final String icon;
  final double value;
  final double step;
  final void Function(double) onChange;

  const NumberFormParam({this.title, this.icon, this.value, this.step=0.5, this.onChange});

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
            FeedFormButton(title: '-', onPressed: () {onChange(value - step);}, textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('$value', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25)),
            ),
            FeedFormButton(title: '+', onPressed: () {onChange(value + step);}, textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),),
          ],
        ),
      ),
    );
  }
}
