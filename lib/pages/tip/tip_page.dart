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
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/tip/tip_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
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
        builder: (context, state) => Scaffold(
              appBar: SGLAppBar('Watering tips'),
              body: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'How to tell when a plant is thirsty?',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: SingleChildScrollView(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Html(data: "<h1>hello</h1><br />pouet"),
                      )),
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
                  Container(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GreenButton(
                        title: 'OK',
                        onPressed: () {
                          BlocProvider.of<MainNavigatorBloc>(context)
                              .add(state.nextRoute);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }
}
