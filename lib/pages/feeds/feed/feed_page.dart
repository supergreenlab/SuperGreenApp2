import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_entries.dart';
import 'package:super_green_app/pages/feeds/feed/feed_bloc.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class FeedPage extends StatelessWidget {
  final Color color;
  final String title;
  final Widget appBar;
  final double appBarHeight;

  const FeedPage({ this.title, @required this.color, this.appBar, this.appBarHeight });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBloc, FeedBlocState>(
      bloc: BlocProvider.of<FeedBloc>(context),
      builder: (BuildContext context, FeedBlocState state) {
        if (state is FeedBlocStateLoaded) {
          return _renderCards(context, state);
        }
        return FullscreenLoading(title: 'Loading feed...');
      },
    );
  }

  Widget _renderCards(BuildContext context, FeedBlocStateLoaded state) {
    return Container(
      color: color,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: color,
            expandedHeight: appBarHeight ?? 200.0,
            flexibleSpace: FlexibleSpaceBar(
              background: this.appBar,
              title: this.appBar == null ? Text(title) : null,
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate(state.entries
                  .map((e) => FeedEntriesHelper.cardForFeedEntry(state.feed, e))
                  .toList()))
        ],
      ),
    );
  }
}
