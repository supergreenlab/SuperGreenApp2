import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class OnboardingPageLayout extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: body(context),
              ),
              Center(
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                  onPressed: () => next(context),
                  child: Text('Next'),
                ),
              )
            ],
          ),
        )
    );
  }

  @protected
  Widget body(BuildContext context);

  @protected
  void next(BuildContext context);

}