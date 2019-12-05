import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_green_app/pages/app_init/bloc/app_init_bloc.dart';
import 'package:super_green_app/pages/main_page/bloc/main_bloc.dart';
import 'package:super_green_app/pages/main_page/ui/main_page.dart';

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
        children: widgets,
      ),
    ));
  }

  Widget _logo() => Expanded(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset("assets/super_green_lab_vertical.svg"),
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
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => BlocProvider(
        create: (context) => MainBloc(),
        child: MainPage(),
      )),
    );
  }
}
