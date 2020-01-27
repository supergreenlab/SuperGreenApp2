import 'package:flutter/material.dart';

class SGLAppBar extends AppBar {
  SGLAppBar(String title)
      : super(
          title: Text(title, style: TextStyle(color: Colors.black)),
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        );
}
