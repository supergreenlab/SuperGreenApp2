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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/widgets/bordered_text.dart';

class MediaList extends StatelessWidget {
  final List<FeedMedia> _medias;
  final String prefix;
  final Function(FeedMedia media) onMediaTapped;

  const MediaList(this._medias, {this.prefix = '', this.onMediaTapped});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Swiper(
            itemCount: _medias.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return _renderImage(
                  context, constraints, _medias[index], '$prefix#${index + 1}');
            },
            pagination: _medias.length > 1
                ? SwiperPagination(
                    builder: new DotSwiperPaginationBuilder(
                        color: Colors.white, activeColor: Color(0xff3bb30b)),
                  )
                : null,
            loop: false,
          );
        },
      ),
    );
  }

  Widget _renderImage(BuildContext context, BoxConstraints constraints,
      FeedMedia media, String label) {
    return InkWell(
      onTap: onMediaTapped != null
          ? () {
              onMediaTapped(media);
            }
          : null,
      child: Stack(children: [
        Hero(
          tag: 'FeedMedia:${media.filePath}',
          child: Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: Image.file(File(media.thumbnailPath)).image))),
        ),
        Positioned(
            child: BorderedText(
              strokeWidth: 3,
              strokeColor: Colors.black,
              child: Text(
                label,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            right: 8.0,
            bottom: 8.0)
      ]),
    );
  }
}
