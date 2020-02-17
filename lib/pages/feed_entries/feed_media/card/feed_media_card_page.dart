import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:super_green_app/pages/feed_entries/feed_media/card/feed_media_card_bloc.dart';
import 'package:super_green_app/widgets/feed_card/feed_card.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_date.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_observations.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_title.dart';
import 'package:super_green_app/widgets/media_list.dart';

class FeedMediaCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedMediaCardBloc, FeedMediaCardBlocState>(
        bloc: BlocProvider.of<FeedMediaCardBloc>(context),
        builder: (context, state) => FeedCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FeedCardTitle('assets/feed_card/icon_media.svg', 'Note taken',
                      state.feedEntry),
                  MediaList(state.medias),
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
