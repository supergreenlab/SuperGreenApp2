import 'package:flutter/material.dart';
import 'package:super_green_app/widgets/pin_screen/constant/constant.dart';

class CustomKeyboard extends StatefulWidget {
  final Function onBackPressed, onPressedKey;
  final TextStyle textStyle;
  final bool showLetters;

  CustomKeyboard({
    this.onBackPressed,
    this.onPressedKey,
    this.textStyle,
    this.showLetters = false,
  });

  CustomKeyboardState createState() => CustomKeyboardState();
}

class CustomKeyboardState extends State<CustomKeyboard> {
  String code = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              buildMaterialButton("1", ''),
              buildMaterialButton("2", 'A B C'),
              buildMaterialButton("3", 'D E F'),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              buildMaterialButton("4", 'G H I'),
              buildMaterialButton("5", 'J K L'),
              buildMaterialButton("6", 'M N O'),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              buildMaterialButton("7", 'P Q R S'),
              buildMaterialButton("8", 'T U V'),
              buildMaterialButton("9", 'W Y X Z'),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                  child: Container()), // Empty Container, to fill the space
              Expanded(
                child: MaterialButton(
                  highlightColor: pinBoxUnderlineColor,
                  onPressed: () => widget.onPressedKey("0"),
                  shape: CircleBorder(side: BorderSide(width: double.infinity)),
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "0",
                    style: widget.textStyle,
                  ),
                ),
              ),
              Expanded(
                child: MaterialButton(
                  highlightColor: pinBoxUnderlineColor,
                  onPressed: () => widget.onBackPressed(),
                  shape: CircleBorder(side: BorderSide(width: double.infinity)),
                  padding: EdgeInsets.all(16),
                  child: Icon(
                    Icons.backspace,
                    color: pinKeyTextColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  MaterialButton buildMaterialButton(String numb, String keys) {
    return MaterialButton(
      onPressed: () => widget.onPressedKey(numb),
      shape: CircleBorder(side: BorderSide(width: double.infinity)),
      padding: EdgeInsets.all(10),
      highlightColor: pinBoxUnderlineColor,
      child: Column(
        children: List.unmodifiable(() sync* {
          yield Text(
            numb,
            style: widget.textStyle,
          );
          if (widget.showLetters) {
            yield SizedBox(height: widget.textStyle.fontSize * 0.5);
            yield Text(
              keys,
              style: TextStyle(
                color: widget.textStyle.color,
                fontSize: widget.textStyle.fontSize * 0.5,
              ),
            );
          }
        }()),
      ),
    );
  }
}
