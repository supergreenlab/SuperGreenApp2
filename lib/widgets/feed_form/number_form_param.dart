import 'package:flutter/material.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_button.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_param_layout.dart';

class NumberFormParam extends StatelessWidget {
  final String title;
  final String icon;
  final double value;
  final String unit;
  final double step;
  final void Function(double) onChange;

  const NumberFormParam(
      {this.title,
      this.icon,
      this.value,
      this.step = 0.5,
      this.onChange,
      this.unit = ''});

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
            ButtonTheme(
                padding: EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 8.0), //adds padding inside the button
                materialTapTargetSize: MaterialTapTargetSize
                    .shrinkWrap, //limits the touch area to the button area
                height: 36,
                minWidth: 60, //wraps child's width
                child: FeedFormButton(
                  title: '-',
                  onPressed: () {
                    onChange(value - step);
                  },
                  textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('$value$unit',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22)),
            ),
            ButtonTheme(
                padding: EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 8.0), //adds padding inside the button
                materialTapTargetSize: MaterialTapTargetSize
                    .shrinkWrap, //limits the touch area to the button area
                height: 36,
                minWidth: 60, //wraps child's width
                child: FeedFormButton(
                  title: '+',
                  onPressed: () {
                    onChange(value + step);
                  },
                  textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                )),
          ],
        ),
      ),
    );
  }
}
