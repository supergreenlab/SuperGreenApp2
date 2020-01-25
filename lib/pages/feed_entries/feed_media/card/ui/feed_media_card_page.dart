import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/pages/feed_entries/feed_media/card/bloc/feed_media_card_bloc.dart';

class FeedMediaCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedMediaCardBloc, FeedMediaCardBlocState>(
        bloc: Provider.of<FeedMediaCardBloc>(context),
        builder: (context, state) => Card(
                color: Color.fromARGB(40, 255, 255, 255),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      leading: state.medias.length == 0 ? Icon(Icons.album) : Image.file(File(state.medias[0].thumbnailPath)),
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: const Text('Note', style: TextStyle(color: Colors.white)),
                      ),
                      subtitle: Text(state.feedEntry.date.toString(), style: TextStyle(color: Colors.white60)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(state.params == null ? '' : state.params['message'], style: TextStyle(color: Colors.white70, fontSize: 17)),
                    )
                  ],
                ),
              ));
  }
}
