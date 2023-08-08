import 'package:flutter/material.dart';

const kPadding8 = EdgeInsets.all(8);
const kPadding16 = EdgeInsets.all(16);
const kPadding24 = EdgeInsets.all(24);


class SglColor {
  static const green = Color(0xFF3BB30B);
  static const inactive = Color(0xFFbdbdbd);
  static const red = Color(0xffC06363);
}

extension SglThemeExtension on BuildContext {
  SizedBox get vBox16 => const SizedBox(height: 16);
}

class SglFilledGreenButton extends SglButton {
  const SglFilledGreenButton({
    required this.title,
    required this.onPressed,
    this.expanded = false,
  }) : super(
    title: title,
    onPressed: onPressed,
    color: SglColor.green,
    expanded: expanded,
    fill: true,
  );

  final String title;
  final VoidCallback onPressed;
  final bool expanded;
}

class SglOutlinedGreenButton extends SglOutlinedButton {
  const SglOutlinedGreenButton({
    required this.title,
    required this.onPressed,
    this.expanded = false,
  }) : super(
    title: title,
    onPressed: onPressed,
    color: SglColor.green,
    expanded: expanded,
  );

  final String title;
  final VoidCallback onPressed;
  final bool expanded;
}

class SglOutlinedRedButton extends SglOutlinedButton {
  const SglOutlinedRedButton({
    required this.title,
    required this.onPressed,
    this.expanded = false,
  }) : super(
    title: title,
    onPressed: onPressed,
    color: SglColor.red,
    expanded: expanded,
  );

  final String title;
  final VoidCallback onPressed;
  final bool expanded;
}

class SglOutlinedButton extends SglButton {
  const SglOutlinedButton({
    required this.title,
    required this.onPressed,
    required this.color,
    this.expanded = false,
  }) : super(
    title: title,
    onPressed: onPressed,
    color: SglColor.red,
    expanded: expanded,
    fill: false,
  );

  final String title;
  final VoidCallback onPressed;
  final Color color;
  final bool expanded;
}

class SglButton extends StatelessWidget {
  const SglButton({
    required this.title,
    required this.onPressed,
    required this.color,
    this.fill = false,
    this.expanded = false,
  });

  final String title;
  final VoidCallback onPressed;
  final Color color;
  final bool fill;
  final bool expanded;

  Widget get _button {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: const StadiumBorder(),
        side: BorderSide(width: 2, color: color),
        backgroundColor: fill ? color : Colors.transparent,
      ),
      child: Padding(
        padding: kPadding16,
        child: Text(
          title,
          style: TextStyle(
            color: fill ? Colors.white : color,
            fontSize: 16,
          ),
        ),
      ),
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return expanded
      ? Row(
          children: [
            Expanded(child: _button),
          ],
        )
      : _button;
  }
}

void showSnackBar(BuildContext context, String text) {
  final snackBar = SnackBar(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      )
    ),
    padding: kPadding16,
    content: Text(
      text,
      style: TextStyle(
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    ),
    backgroundColor: SglColor.green,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
