import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_topping/card/feed_topping_card_bloc.dart';
import 'package:super_green_app/widgets/feed_card/feed_card.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_date.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_observations.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_title.dart';
import 'package:super_green_app/widgets/media_list.dart';

class FeedToppingCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedToppingCardBloc, FeedToppingCardBlocState>(
        bloc: BlocProvider.of<FeedToppingCardBloc>(context),
        builder: (context, state) => FeedCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FeedCardTitle('assets/feed_card/icon_topping.svg', 'Topping',
                      state.feedEntry),
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
                  ),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FeedCardDate(state.feedEntry),
                  ),
                  FeedCardObservations(state.params['message'] ?? '')
                ],
              ),
            ));
  }
}
