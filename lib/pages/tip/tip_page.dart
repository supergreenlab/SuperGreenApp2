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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/tip/tip_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';

class TipPage extends StatefulWidget {
  @override
  _TipPageState createState() => _TipPageState();
}

class _TipPageState extends State<TipPage> {
  bool dontShow = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TipBloc, TipBlocState>(
        bloc: BlocProvider.of<TipBloc>(context),
        builder: (BuildContext context, TipBlocState state) {
          Widget body;
          if (state is TipBlocStateInit) {
            body = FullscreenLoading(title: 'Loading..');
          } else if (state is TipBlocStateLoaded) {
            body = _renderBody(context, state);
          }
          return Scaffold(
            appBar: SGLAppBar('Watering tips'),
            body: Column(
              children: <Widget>[
                Expanded(
                  child: AnimatedSwitcher(
                      duration: Duration(microseconds: 200), child: body),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GreenButton(
                      title: state is TipBlocStateLoaded ? 'OK' : 'SKIP',
                      onPressed: () {
                        BlocProvider.of<MainNavigatorBloc>(context)
                            .add(state.nextRoute);
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _renderBody(BuildContext context, TipBlocStateLoaded state) {
    List<Widget> sections = [
      _renderSection(state.body['article']['intro']),
    ];
    List<Map<String, dynamic>> ss = state.body['article']['sections'];
    if (ss != null) {
      sections.addAll(ss.map((e) => _renderSection(e)));
    }
    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          state.body['article']['title'],
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(children: sections),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Theme(
              data: ThemeData(unselectedWidgetColor: Colors.black),
              child: Checkbox(
                  activeColor: Colors.black,
                  checkColor: Colors.black,
                  value: dontShow,
                  onChanged: (bool value) {
                    setState(() {
                      dontShow = value;
                    });
                  }),
            ),
            Text('Don’t show me this again',
                style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
    ]);
  }

  Widget _renderSection(Map<String, dynamic> section) {
    return Column(
      children: <Widget>[
        Text(section['title'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        MarkdownBody(
          data: section['text'],
          styleSheet:
              MarkdownStyleSheet(p: TextStyle(color: Colors.black, fontSize: 16)),
        ),
      ],
    );
  }
}
