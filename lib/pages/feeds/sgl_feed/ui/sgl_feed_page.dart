import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/ui/feed_page.dart';
import 'package:super_green_app/pages/feeds/sgl_feed/bloc/sgl_feed_bloc.dart';

class SGLFeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SuperGreenLab'),
      ),
      body: BlocBuilder<SGLFeedBloc, SGLFeedBlocState>(
        bloc: Provider.of<SGLFeedBloc>(context),
        builder: (BuildContext context, SGLFeedBlocState state) {
          return _renderFeed(context, state);
        },
      ),
    );
  }

  Widget _renderFeed(BuildContext context, SGLFeedBlocState state) {
    return BlocProvider(
      create: (context) => FeedBloc(1),
      child: FeedPage(),
    );
  }
}
