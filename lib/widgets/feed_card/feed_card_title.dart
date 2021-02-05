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

class FeedCardTitle extends StatelessWidget {
  final String icon;
  final String title;
  final bool synced;
  final Function onEdit;
  final Function onDelete;
  final Function onShare;
  final bool showSyncStatus;
  final bool showControls;
  final List<Widget> actions;

  const FeedCardTitle(this.icon, this.title, this.synced,
      {this.onEdit, this.onDelete, this.onShare, this.showSyncStatus = true, this.showControls = true, this.actions});

  @override
  Widget build(BuildContext context) {
    List<Widget> content = <Widget>[
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child:
            SizedBox(width: 40, height: 40, child: icon.endsWith('svg') ? SvgPicture.asset(icon) : Image.asset(icon)),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300, color: Colors.black87)),
            showSyncStatus
                ? Text(synced ? 'Synced' : 'Not synced', style: TextStyle(color: synced ? Colors.green : Colors.red))
                : Container(),
          ],
        ),
      ),
      Expanded(
        child: Container(),
      ),
    ];
    if (onShare != null && showControls) {
      content.add(
        IconButton(
          icon: Icon(
            Icons.share,
            color: Colors.grey,
          ),
          onPressed: onShare,
        ),
      );
    }
    if (onEdit != null && showControls) {
      content.add(
        IconButton(
          icon: Icon(
            Icons.edit,
            color: Colors.grey,
          ),
          onPressed: onEdit,
        ),
      );
    }
    if (onDelete != null && showControls) {
      content.add(
        IconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.grey,
          ),
          onPressed: () {
            _deleteFeedEntry(context);
          },
        ),
      );
    }
    content.addAll(actions ?? []);
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 0, top: 3.0, bottom: 3.0),
      child: Row(
        children: content,
      ),
    );
  }

  Future _deleteFeedEntry(BuildContext context) async {
    bool confirm = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete this card?'),
            content: Text('This can\'t be reverted. Continue?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text('NO'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text('YES'),
              ),
            ],
          );
        });
    if (confirm) {
      onDelete();
    }
  }
}
