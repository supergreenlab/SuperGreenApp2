import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

class FeedFormMediaList extends StatelessWidget {
  final List<FeedMediasCompanion> medias;
  final void Function(FeedMediasCompanion) onPressed;

  const FeedFormMediaList({this.medias, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return _renderMedias(context);
  }

  Widget _renderMedias(BuildContext context) {
    List<Widget> medias = this
        .medias
        .map((m) => _renderMedia(
              context,
              () {},
              Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image:
                              Image.file(File(m.thumbnailPath.value)).image))),
            ))
        .toList();
    medias.add(_renderMedia(context, () {
      onPressed(null);
    },
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: SvgPicture.asset('assets/feed_form/icon_add.svg'),
        )));
    return SizedBox(
      height: 80,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: medias,
      ),
    );
  }

  Widget _renderMedia(
      BuildContext context, Function onPressed, Widget content) {
    return SizedBox(
        width: 90,
        height: 80,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: RawMaterialButton(
            onPressed: onPressed,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10)),
                child: content),
          ),
        ));
  }
}
