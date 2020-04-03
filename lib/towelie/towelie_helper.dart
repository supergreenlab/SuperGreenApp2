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

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:super_green_app/local_notification/local_notification.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';

class TowelieHelperButton {
  final String title;
  final Map<String, dynamic> params;

  TowelieHelperButton(this.title, this.params);
}

class TowelieHelperReminder {
  final String text;
  final int notificationId;
  final String notificationTitle;
  final String notificationBody;
  final int afterMinutes;

  TowelieHelperReminder(this.text, this.notificationId, this.notificationTitle,
      this.notificationBody, this.afterMinutes);
}

class TowelieHelperPushRoute {
  final String title;
  final MainNavigatorEvent route;

  TowelieHelperPushRoute(this.title, this.route);
}

class TowelieHelper extends StatefulWidget {
  final RouteSettings settings;

  const TowelieHelper({Key key, @required this.settings}) : super(key: key);

  @override
  _TowelieHelperState createState() => _TowelieHelperState();

  static Widget wrapWidget(
      RouteSettings settings, BuildContext context, Widget widget) {
    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<TowelieBloc>(context)
            .add(TowelieBlocEventRoutePop(settings));
        return true;
      },
      child: Stack(children: [
        widget,
        TowelieHelper(settings: settings),
      ]),
    );
  }
}

class _TowelieHelperState extends State<TowelieHelper> {
  Timer _timer;
  String text = '';
  bool visible = false;
  double y = 350;

  @override
  Widget build(BuildContext context) {
    return BlocListener<TowelieBloc, TowelieBlocState>(
      listener: (BuildContext context, TowelieBlocState state) {
        if (state is TowelieBlocStateHelper &&
            state.settings.name == widget.settings.name) {
          _prepareShow(state);
        } else if (state is TowelieBlocStateHelperPop &&
            state.settings.name == widget.settings.name) {
          _prepareHide();
        }
      },
      child: BlocBuilder<TowelieBloc, TowelieBlocState>(
        condition: (context, state) =>
            state is TowelieBlocStateHelper &&
            state.settings.name == widget.settings.name,
        builder: (BuildContext context, TowelieBlocState state) {
          if (visible) {
            return _renderBody(state as TowelieBlocStateHelper);
          }
          return Container();
        },
      ),
    );
  }

  Widget _renderBody(TowelieBlocStateHelper state) {
    List<Widget> content = <Widget>[
      Padding(
          padding: const EdgeInsets.all(16.0),
          child: MarkdownBody(
            data: state.text,
            styleSheet: MarkdownStyleSheet(
                strong: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.normal),
                p: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w300)),
          ))
    ];
    List<Widget> buttons = [];
    if (state.reminders != null) {
      state.reminders.forEach((reminder) {
        buttons.add(FlatButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: () async {
              BlocProvider.of<LocalNotificationBloc>(context).add(
                  LocalNotificationBlocEventReminder(
                      reminder.notificationId,
                      reminder.afterMinutes,
                      reminder.notificationTitle,
                      reminder.notificationBody));
              _prepareHide();
            },
            child: Text(reminder.text.toUpperCase(),
                style: TextStyle(color: Colors.blue, fontSize: 12))));
      });
    }
    if (state.buttons != null && state.buttons.length > 0) {
      for (int i = 0; i < state.buttons.length; ++i) {
        TowelieHelperButton button = state.buttons[i];
        buttons.add(FlatButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: () {
              BlocProvider.of<TowelieBloc>(context)
                  .add(TowelieBlocEventHelperButton(widget.settings, button));
            },
            child: Text(button.title.toUpperCase(),
                style: TextStyle(color: Colors.blue, fontSize: 12))));
      }
    }
    if (state.pushRoute != null) {
      buttons.add(FlatButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onPressed: () {
            BlocProvider.of<MainNavigatorBloc>(context)
                .add(state.pushRoute.route);
          },
          child: Text(state.pushRoute.title.toUpperCase(),
              style: TextStyle(color: Colors.blue, fontSize: 12))));
    }
    if (state.hasNext) {
      buttons.add(FlatButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onPressed: () {
            BlocProvider.of<TowelieBloc>(context)
                .add(TowelieBlocEventHelperNext(widget.settings));
          },
          child: Text('Next'.toUpperCase(),
              style: TextStyle(color: Colors.blue, fontSize: 12))));
    }
    if (buttons.length > 0) {
      content.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: buttons,
            ),
          ),
        ),
      );
    }
    return Positioned(
      bottom: 0,
      left: 0,
      child: Material(
        color: Colors.transparent,
        child: AnimatedContainer(
          curve: Curves.elasticInOut,
          duration: Duration(milliseconds: 1000),
          transform: Matrix4.translationValues(0, y, 0),
          width: MediaQuery.of(context).size.width,
          color: Colors.transparent,
          child: Dismissible(
            direction: DismissDirection.down,
            key: Key('Towelie'),
            onDismissed: (direction) {
              setState(() {
                visible = false;
              });
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [BoxShadow(blurRadius: 2, color: Colors.black38, offset: Offset(2, 2))],
                        border: Border.all(color: Colors.black26, width: 1),
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Column(
                      children: content,
                    ),
                  ),
                )),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 4.0, bottom: 8.0, left: 2.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffdedede), width: 2),
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(pi),
                        child: SizedBox(
                            width: 60,
                            height: 60,
                            child: Image.asset(
                                'assets/feed_card/icon_towelie.png'))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _prepareShow(TowelieBlocStateHelper state) {
    setState(() {
      text = state.text;
      visible = true;
      y = 350;
    });
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: 50), () {
      _timer = null;
      setState(() {
        y = 0;
      });
    });
  }

  void _prepareHide() {
    setState(() {
      y = 350;
    });
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: 1000), () {
      _timer = null;
      setState(() {
        visible = false;
      });
    });
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    super.dispose();
  }
}
