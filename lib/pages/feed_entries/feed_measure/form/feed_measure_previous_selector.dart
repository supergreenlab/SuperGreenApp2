import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

class FeedMeasurePreviousSelector extends StatefulWidget {
  final List<FeedMedia> _measures;
  final Function(FeedMedia) _onSelect;

  const FeedMeasurePreviousSelector(this._measures, this._onSelect, {Key key})
      : super(key: key);

  @override
  _FeedMeasurePreviousSelectorState createState() => _FeedMeasurePreviousSelectorState();
}

class _FeedMeasurePreviousSelectorState extends State<FeedMeasurePreviousSelector> {

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              child: Swiper(
                onTap: (i) {
                  widget._onSelect(widget._measures[i]);
                },
                itemCount: widget._measures.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: FittedBox(fit: BoxFit.contain, child: Image.file(File(widget._measures[index].thumbnailPath))),
                  );
                },
                pagination: widget._measures.length > 1
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

    @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}
