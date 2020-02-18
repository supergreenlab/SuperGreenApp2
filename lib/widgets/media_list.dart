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
      onTap: onMediaTapped != null ? () { onMediaTapped(media); } : null,
          child: Stack(children: [
        Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: Image.file(File(media.thumbnailPath)).image))),
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
