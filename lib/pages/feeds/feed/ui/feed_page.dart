import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';

class FeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBloc, FeedBlocState>(
      bloc: Provider.of<FeedBloc>(context),
      builder: (BuildContext context, FeedBlocState state) {
        return Text('FeedPage ${state.feed.name} ${state.feed.id}');
      },
    );
  }
}