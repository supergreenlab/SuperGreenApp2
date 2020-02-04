import 'package:flutter/material.dart';

class SGLAppBar extends AppBar {
  SGLAppBar(String title, {List<Widget> actions, bool hideBackButton=false})
      : super(
          automaticallyImplyLeading: !hideBackButton,
          title: Text(title, style: TextStyle(color: Colors.black)),
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          actions: actions,
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 1.0,
        );
}
