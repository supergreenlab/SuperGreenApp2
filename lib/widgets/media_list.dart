import 'dart:io';

import 'package:flutter/material.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

class MediaList extends StatelessWidget {
  final List<FeedMedia> _medias;
  final String prefix;

  const MediaList(this._medias, {this.prefix=''});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          int i = 0;
          return ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: _medias
                .map((m) => _renderImage(context, constraints, m, '$prefix#${++i}'))
                .toList(),
          );
        },
      ),
    );
  }

  Widget _renderImage(BuildContext context, BoxConstraints constraints,
      FeedMedia media, String label) {
    return Stack(children: [
      Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: Image.file(File(media.thumbnailPath)).image))),
      Positioned(
          child: Text(
            label,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40),
          ),
          right: 8.0,
          bottom: 8.0)
    ]);
  }
}
