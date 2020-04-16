import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_media/card/feed_media_card_bloc.dart';
import 'package:super_green_app/widgets/feed_card/feed_card.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_date.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_title.dart';
import 'package:super_green_app/widgets/media_list.dart';

class FeedProductsPage extends StatefulWidget {
  final Animation animation;

  const FeedProductsPage(this.animation, {Key key}) : super(key: key);

  @override
  _FeedProductsPageState createState() => _FeedProductsPageState();
}

class _FeedProductsPageState extends State<FeedProductsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedMediaCardBloc, FeedMediaCardBlocState>(
        bloc: BlocProvider.of<FeedMediaCardBloc>(context),
        builder: (context, state) {
          var widget;
          return FeedCard(
            animation: widget.animation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FeedCardTitle(
                  'assets/feed_card/icon_media.svg',
                  'Products',
                  state.feedEntry,
                  onEdit: () {},
                ),
                state.medias.length > 0
                    ? MediaList(
                        state.medias,
                        onMediaTapped: (media) {
                          BlocProvider.of<MainNavigatorBloc>(context)
                              .add(MainNavigateToFullscreenMedia(media));
                        },
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: FeedCardDate(state.feedEntry),
                ),
              ],
            ),
          );
        });
  }
}
