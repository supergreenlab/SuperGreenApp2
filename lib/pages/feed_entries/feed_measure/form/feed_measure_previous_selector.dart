import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

class FeedMeasurePreviousSelector extends StatelessWidget {
  final List<FeedMedia> _measures;
  final Function(FeedMedia) _onSelect;

  const FeedMeasurePreviousSelector(this._measures, this._onSelect, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              child: Swiper(
                onTap: (i) {
                  _onSelect(_measures[i]);
                },
                itemCount: _measures.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: FittedBox(fit: BoxFit.cover, child: Image.file(File(_measures[index].thumbnailPath))),
                  );
                },
                pagination: _measures.length > 1
                    ? SwiperPagination(
                        builder: new DotSwiperPaginationBuilder(
                            color: Colors.white,
                            activeColor: Color(0xff3bb30b)),
                      )
                    : null,
                loop: false,
              ),
            );
          },
        ));
  }
}
