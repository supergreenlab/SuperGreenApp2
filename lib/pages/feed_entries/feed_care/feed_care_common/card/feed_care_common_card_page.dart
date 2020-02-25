import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_care/feed_care_common/card/feed_care_common_card_bloc.dart';
import 'package:super_green_app/widgets/feed_card/feed_card.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_date.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_observations.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_title.dart';
import 'package:super_green_app/widgets/media_list.dart';

abstract class FeedCareCommonCardPage<CardBloc extends FeedCareCommonCardBloc>
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CardBloc, FeedCareCommonCardBlocState>(
        bloc: BlocProvider.of<CardBloc>(context),
        builder: (context, state) {
          List<Widget> body = [
            FeedCardTitle(iconPath(), title(), state.feedEntry),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FeedCardDate(state.feedEntry),
            ),
            FeedCardObservations(state.params['message'] ?? '')
          ];
          if (state.beforeMedias.length > 0) {
            body.insert(
              1,
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: MediaList(
                  state.beforeMedias,
                  prefix: 'Before ',
                  onMediaTapped: (media) {
                    BlocProvider.of<MainNavigatorBloc>(context)
                        .add(MainNavigateToFullscreenMedia(media));
                  },
                ),
              ),
            );
          }
          if (state.afterMedias.length > 0) {
            body.insert(
                1,
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: MediaList(
                    state.afterMedias,
                    prefix: 'After ',
                    onMediaTapped: (media) {
                      BlocProvider.of<MainNavigatorBloc>(context)
                          .add(MainNavigateToFullscreenMedia(media));
                    },
                  ),
                ));
          }
          return FeedCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: body,
            ),
          );
        });
  }

  String title();
  String iconPath();
}
