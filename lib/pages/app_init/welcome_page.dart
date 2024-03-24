/*
 * Copyright (C) 2022  SuperGreenLab <towelie@supergreenlab.com>
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/app_init/app_init_bloc.dart';
import 'package:super_green_app/widgets/green_button.dart';

class WelcomePage extends StatefulWidget {
  static String get formAllowAnalytics {
    return Intl.message(
      '''**Help us** discern what's **useful** from what's **useless** by sharing **anonymous** usage data.''',
      name: 'formAllowAnalytics',
      desc: 'Form allow analytics',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get formCGU {
    return Intl.message(
      '''\*By proceeding, **you explicitly agree** that you are acting in coordinance with local, state, and federal or national laws. **SuperGreenLab will not be liable** for
consequences surrounding the legality of how the app, lights or grow bundle are used. ''',
      name: 'formCGU',
      desc: 'Form CGU',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  final _loading;

  WelcomePage(this._loading);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _acceptCGU = false;
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
      child: MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaleFactor: 1, boldText: false),
        child: Scaffold(
            body: Container(
          padding: EdgeInsets.all(4),
          child: AnimatedSwitcher(
              duration: Duration(milliseconds: 250),
              child: Column(
                key: ValueKey<bool>(widget._loading),
                mainAxisAlignment: MainAxisAlignment.center,
                children: widgets,
              )),
        )),
      ),
    );
  }

  Widget _logo() {
    List<Widget> body = <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 48.0),
        child: SizedBox(
            width: 200,
            height: 200,
            child: SvgPicture.asset('assets/super_green_lab_vertical.svg')),
      ),
    ];
    if (!widget._loading) {
      body.add(
        Expanded(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
                child: _renderOptionCheckbx(
                    context, WelcomePage.formAllowAnalytics, (bool? newValue) {
                  setState(() {
                    _allowAnalytics = newValue!;
                  });
                }, _allowAnalytics),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: _renderOptionCheckbx(context, WelcomePage.formCGU,
                    (bool? newValue) {
                  setState(() {
                    _acceptCGU = newValue!;
                  });
                }, _acceptCGU),
              ),
            ],
          ),
        ),
      );
    }
    return Expanded(
      child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center, children: body)),
    );
  }

  Widget _nextButton(BuildContext context) {
    return SafeArea(
      child: GreenButton(
        onPressed: _acceptCGU ? () => _next(context) : null,
        title: 'Next',
      ),
    );
  }

  void _next(BuildContext context) {
    BlocProvider.of<AppInitBloc>(context)
        .add(AppInitBlocEventAllowAnalytics(_allowAnalytics));
  }

  Widget _renderOptionCheckbx(BuildContext context, String text,
      Function(bool?) onChanged, bool value) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Checkbox(
            onChanged: onChanged,
            value: value,
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                onChanged(!value);
              },
              child: MarkdownBody(
                fitContent: true,
                data: text,
                styleSheet: MarkdownStyleSheet(
                    p: TextStyle(color: Colors.black, fontSize: 14)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
