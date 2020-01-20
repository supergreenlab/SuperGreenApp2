import 'package:flutter/material.dart';

class FeedFormButton extends StatelessWidget {
  final String title;
  final bool border;
  final TextStyle textStyle;
  final void Function() onPressed;

  const FeedFormButton({this.title, this.border=false, this.onPressed, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black12,
        border: Border.all(color: border ? Colors.white : Colors.transparent, width: 2),
        borderRadius: BorderRadius.circular(5),
      ),
      child: FlatButton(
        highlightColor: Colors.white54,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onPressed: onPressed,
        child: Text(
          title,
          style: this.textStyle ?? TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}