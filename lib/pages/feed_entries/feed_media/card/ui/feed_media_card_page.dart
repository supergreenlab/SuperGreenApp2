import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/pages/feed_entries/feed_media/card/bloc/feed_media_card_bloc.dart';

class FeedMediaCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedMediaCardBloc, FeedMediaCardBlocState>(
        bloc: Provider.of<FeedMediaCardBloc>(context),
        builder: (context, state) => Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    leading: state.medias.length == 0
                        ? SvgPicture.asset('assets/feed_card/icon_dimming.svg')
                        : _renderImage(context, state),
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: const Text('Note', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    subtitle: Text(state.feedEntry.date.toString(),
                        style: TextStyle(color: Colors.black54)),
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

  Widget _renderImage(BuildContext context, FeedMediaCardBlocState state) {
    return Container(
        width: 45.0,
        height: 45.0,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(5),
            image: DecorationImage(
                fit: BoxFit.cover,
                image: Image.file(File(state.medias[0].thumbnailPath)).image)));
  }
}
