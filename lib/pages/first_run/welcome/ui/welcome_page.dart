import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/app_init/bloc/app_init_bloc.dart';
import 'package:super_green_app/widgets/button_ok.dart';

class WelcomePage extends StatelessWidget {
  final _loading;

  WelcomePage(this._loading);

  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[this._logo()];
    if (this._loading == false) {
      widgets.add(this._nextButton(context));
    }
    return Scaffold(
        body: Container(
      padding: EdgeInsets.all(10),
      child: AnimatedSwitcher(
          duration: Duration(milliseconds: 250),
          child: Column(
            key: ValueKey<bool>(_loading),
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: widgets,
          )),
    ));
  }

  Widget _logo() => Expanded(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                  width: 200,
                  height: 300,
                  child:
                      SvgPicture.asset("assets/super_green_lab_vertical.svg")),
              Text(
                _loading ? 'Loading..' : 'Welcome to SuperGreenLab!',
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
        child: ButtonOK(
          onPressed: () => _next(context),
          text: 'Next',
          themeData: Theme.of(context),
        ),
      );

  _next(BuildContext context) {
    BlocProvider.of<AppInitBloc>(context).done();
    BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToHomeEvent());
  }
}
