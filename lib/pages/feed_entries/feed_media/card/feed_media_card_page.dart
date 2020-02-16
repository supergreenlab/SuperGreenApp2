import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/feed_entries/feed_media/card/feed_media_card_bloc.dart';
import 'package:super_green_app/widgets/feed_card_date.dart';

class FeedMediaCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedMediaCardBloc, FeedMediaCardBlocState>(
        bloc: BlocProvider.of<FeedMediaCardBloc>(context),
        builder: (context, state) => Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    leading:
                        SvgPicture.asset('assets/feed_card/icon_media.svg'),
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: const Text('Note taken',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    subtitle: FeedCardDate(state.feedEntry),
                  ),
                  Container(
                    height: 300,
                    child: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        int i = 0;
                        return ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: state.medias
                              .map((m) => _renderImage(context, constraints, m, '${++i}'))
                              .toList(),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        state.params == null ? '' : state.params['message'],
                        style: TextStyle(color: Colors.black54, fontSize: 17)),
                  )
                ],
              ),
            ));
  }

  Widget _renderImage(
      BuildContext context, BoxConstraints constraints, FeedMedia media, String label) {
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
