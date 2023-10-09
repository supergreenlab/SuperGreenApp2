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

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';

class AppBarAction extends StatelessWidget {
  final String? icon;
  final Widget? iconWidget;
  final Color color;
  final String title;
  final Widget? titleIcon;
  final Widget? content;
  final Function()? action;
  final Widget? actionIcon;
  final bool center;
  final bool shadowed;
  final bool addIcon;
  final Widget? child;

  final Function()? onCheck;
  final Function()? onSkip;

  final double height;

  const AppBarAction({
    Key? key,
    this.icon,
    this.iconWidget,
    required this.color,
    required this.title,
    this.titleIcon,
    this.content,
    this.action,
    this.actionIcon,
    this.height = 65,
    this.center = false,
    this.shadowed = true,
    this.addIcon = true,
    this.onCheck,
    this.onSkip,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget bodyContent = Row(
      children: [
        renderIcon(context),
        Expanded(child: renderBody(context)),
        actionIcon != null ? renderButton(context) : Container(),
      ],
    );
    if (this.child != null) {
      bodyContent = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          bodyContent,
          this.child!,
        ],
      );
    }
    Widget body = InkWell(
      onTap: action,
      child: Container(
        clipBehavior: !shadowed ? Clip.none : Clip.hardEdge,
        decoration: !shadowed
            ? null
            : BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(50),
                    spreadRadius: 2.0,
                    blurRadius: 2.0,
                    offset: Offset(1, 1),
                  )
                ],
              ),
        child: bodyContent,
      ),
    );

    if (onCheck != null && onSkip != null) {
      List<Widget> items = [
        SlidableAction(
          // An action can be bigger than the others.
          onPressed: (context) {
            onCheck!();
          },
          backgroundColor: Color(0xFF7BC043),
          foregroundColor: Colors.white,
          icon: Icons.done,
          label: 'Done',
        ),
        SlidableAction(
          onPressed: (context) {
            onSkip!();
          },
          backgroundColor: Color(0xFF0392CF),
          foregroundColor: Colors.white,
          icon: Icons.skip_next,
          label: 'Skip',
        ),
      ];
      return Slidable(
        // The end action pane is the one at the right or the bottom side.
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          children: items,
        ),

        child: body,
      );
    }
    return body;
  }

  Widget renderIcon(BuildContext context) {
    if (this.icon == null && this.iconWidget == null) {
      return Container();
    }
    const iconSize = 40.0;
    return Container(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(iconSize / 2),
                  color: Colors.white,
                ),
                child: this.iconWidget ??
                    SvgPicture.asset(this.icon!, width: iconSize, height: iconSize, fit: BoxFit.contain)),
          ),
        ],
      ),
    );
  }

  Widget renderBody(BuildContext context) {
    Widget top = AutoSizeText(title, maxLines: 1, style: TextStyle(color: color, fontWeight: FontWeight.bold));
    if (titleIcon != null) {
      top = Row(children: [top, titleIcon!]);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          top,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: center ? CrossAxisAlignment.center : CrossAxisAlignment.stretch,
            children: [
              content ?? Container(),
            ],
          )
        ],
      ),
    );
  }

  Widget renderButton(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: addIcon ? Stack(
                clipBehavior: Clip.none,
                children: [
                  actionIcon!,
                  Positioned(
                    right: -5,
                    bottom: -10,
                    child: Text('+', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 93, 96, 147)),),
                  ),
                ],
              ) : actionIcon!),
        ),
      ],
    );
  }
}
