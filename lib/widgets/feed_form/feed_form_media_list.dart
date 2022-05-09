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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_green_app/data/rel/feed/feeds.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

class FeedFormMediaList extends StatelessWidget {
  final List<FeedMediasCompanion> medias;
  final void Function(FeedMediasCompanion?) onPressed;
  final void Function(FeedMediasCompanion) onLongPressed;
  final int maxMedias;

  const FeedFormMediaList(
      {required this.medias, required this.onPressed, required this.onLongPressed, this.maxMedias = -1});

  @override
  Widget build(BuildContext context) {
    return _renderMedias(context);
  }

  Widget _renderMedias(BuildContext context) {
    List<Widget> medias = this
        .medias
        .map((m) => _renderMedia(
              context,
              () {
                onPressed(m);
              },
              () {
                onLongPressed(m);
              },
              Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: Image.file(File(FeedMedias.makeAbsoluteFilePath(m.thumbnailPath.value))).image))),
            ))
        .toList();
    if (maxMedias == -1 || maxMedias > this.medias.length) {
      medias.add(_renderMedia(context, () {
        onPressed(null);
      },
          null,
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
            child: SvgPicture.asset('assets/feed_form/icon_add.svg'),
          )));
    }
    return SizedBox(
      height: 80,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: medias,
      ),
    );
  }

  Widget _renderMedia(BuildContext context, Function() onPressed, Function()? onLongPressed, Widget content) {
    return SizedBox(
        width: 70,
        height: 80,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0),
          child: RawMaterialButton(
            onPressed: onPressed,
            onLongPress: onLongPressed,
            child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)), child: content),
          ),
        ));
  }
}
