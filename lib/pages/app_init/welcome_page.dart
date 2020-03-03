/*
 * Copyright (C) 2018  SuperGreenLab <towelie@supergreenlab.com>
 * Author: Constantin Clauzel <constantin.clauzel@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/app_init/app_init_bloc.dart';
import 'package:super_green_app/widgets/green_button.dart';

class WelcomePage extends StatelessWidget {
  final _loading;

  WelcomePage(this._loading);

  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[this._logo()];
    if (this._loading == false) {
      widgets.add(Align(
          alignment: Alignment.centerRight, child: this._nextButton(context)));
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
                      SvgPicture.asset('assets/super_green_lab_vertical.svg')),
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

  Widget _nextButton(BuildContext context) {
    return GreenButton(
      onPressed: () => _next(context),
      title: 'Next',
    );
  }

  void _next(BuildContext context) {
    BlocProvider.of<AppInitBloc>(context).done();
    BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToHomeEvent());
  }
}
