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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

class FeedCardTitle extends StatelessWidget {
  final String icon;
  final String title;
  final FeedEntry feedEntry;
  final Function onEdit;

  const FeedCardTitle(this.icon, this.title, this.feedEntry,
      {this.onEdit});

  @override
  Widget build(BuildContext context) {
    List<Widget> content = <Widget>[
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: SizedBox(
            width: 40,
            height: 40,
            child: icon.endsWith('svg')
                ? SvgPicture.asset(icon)
                : Image.asset(icon)),
      ),
      Text(title,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w300,
              color: Colors.black87)),
    ];
    if (onEdit != null) {
      content.addAll([
        Expanded(
          child: Container(),
        ),
        IconButton(
          icon: Icon(
            Icons.edit,
            color: Colors.grey,
          ),
          onPressed: onEdit,
        ),
      ]);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 3.0),
      child: Row(
        children: content,
      ),
    );
  }
}
