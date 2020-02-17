import 'package:flutter/material.dart';

class FeedCardObservations extends StatelessWidget {
  final String message;

  const FeedCardObservations(this.message);

  @override
  Widget build(BuildContext context) {
    return Padding(
                    padding: const EdgeInsets.only(
                        top: 16.0, left: 8.0, right: 8.0, bottom: 16.0),
                    child: Text(message,
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                  );
  }

}