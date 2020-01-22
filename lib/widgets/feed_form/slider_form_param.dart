import 'package:flutter/material.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_param_layout.dart';

class SliderFormParam extends StatelessWidget {
  final double value;
  final void Function(double) onChanged;
  final void Function(double) onChangeEnd;
  final String title;
  final String icon;
  final Color color;

  const SliderFormParam({Key key, @required this.title, @required this.icon, @required this.value, @required this.onChanged, @required this.onChangeEnd, @required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FeedFormParamLayout(
      title: title,
      icon: icon,
      child: Slider(
        min: 0,
        max: 100,
        onChangeEnd: onChangeEnd,
        value: value,
        activeColor: color,
        onChanged: onChanged,
      ),
    );
  }
}
