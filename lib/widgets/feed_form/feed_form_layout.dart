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
import 'package:super_green_app/widgets/appbar.dart';

class FeedFormLayout extends StatelessWidget {
  final Widget body;
  final bool valid;
  final bool changed;
  final void Function()? onOK;
  final void Function()? onCancel;
  final void Function()? onSettings;
  final String title;
  final bool hideBackButton;
  final double fontSize;
  final double topBarPadding;

  const FeedFormLayout(
      {required this.body,
      required this.onOK,
      required this.title,
      this.onCancel,
      this.onSettings,
      this.valid = true,
      this.changed = false,
      this.hideBackButton = false,
      this.fontSize = 23,
      this.topBarPadding = 8.0});

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];
    if (this.onSettings != null) {
      actions.add(IconButton(
        icon: Icon(Icons.settings, color: Color(this.valid ? 0xff3bb30b : 0xa0ffffff), size: 40),
        onPressed: onSettings,
      ));
    }
    if (this.onOK != null) {
      actions.add(IconButton(
        icon: Icon(Icons.check, color: Color(this.valid ? 0xff3bb30b : 0xa0ffffff), size: 40),
        onPressed: this.valid ? onOK : null,
      ));
    }
    return WillPopScope(
      onWillPop: () async {
        if (this.changed) {
          return (await showDialog<bool>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Unsaved changed'),
                      content: Text('Changes will not be saved. Continue?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: Text('NO'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                            if (onCancel != null) {
                              onCancel!();
                            }
                          },
                          child: Text('YES'),
                        ),
                      ],
                    );
                  })) ??
              false;
        }
        return true;
      },
      child: Scaffold(
          appBar: SGLAppBar(
            title,
            fontSize: fontSize,
            actions: actions,
            hideBackButton: hideBackButton,
            backgroundColor: Colors.blueGrey,
            titleColor: Colors.white,
            iconColor: Colors.white,
          ),
          body: Padding(
            padding: EdgeInsets.only(top: topBarPadding),
            child: this.body,
          )),
    );
  }
}
