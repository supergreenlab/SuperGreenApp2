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
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/app_init/app_init_bloc.dart';
import 'package:super_green_app/widgets/green_button.dart';

class WelcomePage extends StatefulWidget {
  final _loading;

  WelcomePage(this._loading);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _allowAnalytics = false;

  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[this._logo()];
    if (this.widget._loading == false) {
      widgets.add(Align(
          alignment: Alignment.centerRight, child: this._nextButton(context)));
    }
    return BlocListener<AppInitBloc, AppInitBlocState>(
      listener: (BuildContext context, AppInitBlocState state) {
        if (state is AppInitBlocStateDone) {
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigateToHomeEvent());
        }
      },
      child: Scaffold(
          body: Container(
        padding: EdgeInsets.all(4),
        child: AnimatedSwitcher(
            duration: Duration(milliseconds: 250),
            child: Column(
              key: ValueKey<bool>(widget._loading),
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: widgets,
            )),
      )),
    );
  }

  Widget _logo() {
    List<Widget> body = <Widget>[
      SizedBox(
          width: 200,
          height: 300,
          child: SvgPicture.asset('assets/super_green_lab_vertical.svg')),
      Text(
        widget._loading ? 'Loading..' : 'Welcome to SuperGreenLab!',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontFamily: 'Roboto',
          letterSpacing: 1,
          fontSize: 20,
        ),
      ),
    ];
    if (!widget._loading) {
      body.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 24.0),
          child: _renderOptionCheckbx(
              context, SGLLocalizations.current.formAllowAnalytics, (newValue) {
            setState(() {
              _allowAnalytics = newValue;
            });
          }, _allowAnalytics),
        ),
      );
    }
    return Expanded(
      child:
          Column(mainAxisAlignment: MainAxisAlignment.center, children: body),
    );
  }

  Widget _nextButton(BuildContext context) {
    return GreenButton(
      onPressed: () => _next(context),
      title: 'Next',
    );
  }

  void _next(BuildContext context) {
    BlocProvider.of<AppInitBloc>(context)
        .add(AppInitBlocEventAllowAnalytics(_allowAnalytics));
  }

  Widget _renderOptionCheckbx(
      BuildContext context, String text, Function(bool) onChanged, bool value) {
    return Row(
      children: <Widget>[
        Checkbox(
          onChanged: onChanged,
          value: value,
        ),
        InkWell(
          onTap: () {
            setState(() {
              _allowAnalytics = !_allowAnalytics;
            });
          },
          child: MarkdownBody(
            data: text,
            styleSheet: MarkdownStyleSheet(
                p: TextStyle(color: Colors.black, fontSize: 14)),
          ),
        ),
      ],
    );
  }
}
