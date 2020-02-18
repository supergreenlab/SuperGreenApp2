import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_defoliation/card/feed_defoliation_card_bloc.dart';
import 'package:super_green_app/widgets/feed_card/feed_card.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_date.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_observations.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_title.dart';
import 'package:super_green_app/widgets/media_list.dart';

class FeedDefoliationCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedDefoliationCardBloc, FeedDefoliationCardBlocState>(
        bloc: BlocProvider.of<FeedDefoliationCardBloc>(context),
        builder: (context, state) => FeedCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FeedCardTitle('assets/feed_card/icon_defoliation.svg', 'Defoliation', state.feedEntry),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: MediaList(state.afterMedias, prefix: 'After '),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: MediaList(state.beforeMedias, prefix: 'Before '),
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
