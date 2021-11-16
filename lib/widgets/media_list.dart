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
import 'package:flutter_svg/svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:super_green_app/pages/feed_entries/common/media_state.dart';
import 'package:super_green_app/widgets/bordered_text.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class MediaList extends StatelessWidget {
  final List<MediaState> _medias;
  final String prefix;
  final Function(MediaState media)? onMediaTapped;
  final Function(int i)? onMediaShown;
  final bool showSyncStatus;
  final bool showTapIcon;

  const MediaList(this._medias,
      {this.prefix = '', this.onMediaTapped, this.showSyncStatus = true, this.showTapIcon = false, this.onMediaShown});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Swiper(
            onIndexChanged: onMediaShown,
            itemCount: _medias.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return _renderImage(context, constraints, _medias[index], '$prefix#${index + 1}');
            },
            pagination: _medias.length > 1
                ? SwiperPagination(
                    builder: new DotSwiperPaginationBuilder(color: Colors.white, activeColor: Color(0xff3bb30b)),
                  )
                : null,
            loop: false,
          );
        },
      ),
    );
  }

  Widget _renderImage(BuildContext context, BoxConstraints constraints, MediaState media, String label) {
    return InkWell(
      onTap: onMediaTapped != null
          ? () {
              onMediaTapped!(media);
            }
          : null,
      child: Stack(children: [
        Hero(
          tag: 'FeedMedia:${media.filePath}',
          child: SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: media.thumbnailPath.startsWith("http")
                  ? Image.network(
                      media.thumbnailPath,
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return FullscreenLoading(
                            percent: loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!);
                      },
                    )
                  : Image.file(File(media.thumbnailPath), fit: BoxFit.cover)),
        ),
        Positioned(
            child: BorderedText(
              strokeWidth: 3,
              strokeColor: Colors.black,
              child: Text(
                label,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            right: 8.0,
            bottom: 8.0),
        isVideo(media.filePath)
            ? Positioned(
                left: constraints.maxWidth / 2 - 38,
                top: constraints.maxHeight / 2 - 48,
                child: SvgPicture.asset('assets/feed_card/play_button.svg'))
            : Container(),
        showSyncStatus
            ? Positioned(
                left: 0,
                bottom: 0,
                child: Container(
                  color: Colors.white54,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(media.synced ? 'Synced' : 'Not synced',
                        style: TextStyle(fontWeight: FontWeight.bold, color: media.synced ? Colors.green : Colors.red)),
                  ),
                ),
              )
            : Container(),
        showTapIcon
            ? Positioned(
                right: 0,
                top: 10,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SvgPicture.asset('assets/feed_card/icon_tap_measure.svg'),
                  ),
                ),
              )
            : Container(),
      ]),
    );
  }

  bool isVideo(String filePath) {
    if (filePath.startsWith('http')) {
      String path = Uri.parse(filePath).path;
      return path.endsWith('mp4');
    } else {
      return filePath.endsWith('mp4');
    }
  }
}
