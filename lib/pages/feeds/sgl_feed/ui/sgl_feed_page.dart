import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/pages/feeds/sgl_feed/bloc/sgl_feed_bloc.dart';

class SGLFeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SGLFeedBloc, SGLFeedBlocState>(
      bloc: Provider.of<SGLFeedBloc>(context),
      builder: (BuildContext context, SGLFeedBlocState state) {
        return Text('FeedPage ${state.feed.name} ${state.feed.id}');
      },
    );
  }
}