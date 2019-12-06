import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/app_init/bloc/app_init_bloc.dart';

class WelcomePage extends StatelessWidget {
  final showNextButton;

  WelcomePage(this.showNextButton);

  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[this._logo()];
    if (this.showNextButton) {
      widgets.add(this._nextButton(context));
    }
    return Scaffold(
        body: Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: widgets,
      ),
    ));
  }

  Widget _logo() => Expanded(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 200,
                height: 300,
                child: SvgPicture.asset("assets/super_green_lab_vertical.svg")
              ),
              Text(
                'Welcome to SuperGreenLab!',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Roboto',
                  letterSpacing: 1,
                  fontSize: 20,
                ),
              )
            ]),
      );

  Widget _nextButton(BuildContext context) => Center(
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),
          onPressed: () => _next(context),
          child: Text('Next'),
        ),
      );

  _next(BuildContext context) {
    BlocProvider.of<AppInitBloc>(context).done();
    BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToHomeEvent());
  }
}
