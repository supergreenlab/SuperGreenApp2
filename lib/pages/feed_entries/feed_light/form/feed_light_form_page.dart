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
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_light/form/feed_light_form_bloc.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_layout.dart';
import 'package:super_green_app/widgets/feed_form/slider_form_param.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedLightFormPage extends StatefulWidget {
  @override
  _FeedLightFormPageState createState() => _FeedLightFormPageState();
}

class _FeedLightFormPageState extends State<FeedLightFormPage> {
  List<int> values = List();

  bool changed = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<FeedLightFormBloc>(context)
            .add(FeedLightFormBlocEventCancel());
        return false;
      },
      child: BlocListener(
        bloc: BlocProvider.of<FeedLightFormBloc>(context),
        listener: (BuildContext context, FeedLightFormBlocState state) {
          if (state is FeedLightFormBlocStateLightsLoaded) {
            setState(() => values = List.from(state.values));
          } else if (state is FeedLightFormBlocStateDone) {
            BlocProvider.of<MainNavigatorBloc>(context)
                .add(MainNavigatorActionPop(mustPop: true));
          }
        },
        child: BlocBuilder<FeedLightFormBloc, FeedLightFormBlocState>(
            bloc: BlocProvider.of<FeedLightFormBloc>(context),
            builder: (context, state) {
              Widget body;
              if (state is FeedLightFormBlocStateNoDevice) {
                body = Stack(
                  children: <Widget>[
                    ListView.builder(
                      itemCount: values.length,
                      itemBuilder: _renderLightParam,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white60),
                      child: Fullscreen(
                        title:
                            'Stretch control\nrequires an SGL controller',
                        child: GreenButton(
                          title: 'SHOP NOW',
                          onPressed: () {
                            launch('https://www.supergreenlab.com');
                          },
                        ),
                        childFirst: false,
                      ),
                    ),
                  ],
                );
              } else {
                body = ListView.builder(
                  itemCount: values.length,
                  itemBuilder: _renderLightParam,
                );
              }
              return FeedFormLayout(
                title: 'Record creation',
                changed: changed,
                valid: changed,
                onOK: () {
                  BlocProvider.of<FeedLightFormBloc>(context)
                      .add(FeedLightFormBlocEventCreate(values));
                },
                body: body,
              );
            }),
      ),
    );
  }

  Widget _renderLightParam(BuildContext context, int i) {
    return SliderFormParam(
      key: Key('$i'),
      title: 'Light ${i + 1}',
      icon: 'assets/feed_form/icon_${values[i] > 30 ? "sun" : "moon"}.svg',
      value: values[i].toDouble(),
      color: _color(values[i]),
      onChanged: (double newValue) {
        setState(() {
          values[i] = newValue.round();
          changed = true;
        });
      },
      onChangeEnd: (double value) {
        BlocProvider.of<FeedLightFormBloc>(context)
            .add(FeedLightFormBlocValueChangedEvent(i, value));
      },
    );
  }

  Color _color(int value) {
    if (value > 60) {
      return Colors.yellow;
    } else if (value > 30) {
      return Colors.orange;
    }
    return Colors.blue;
  }
}
