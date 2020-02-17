import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_schedule/card/feed_schedule_card_bloc.dart';
import 'package:super_green_app/widgets/feed_card/feed_card.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_date.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_title.dart';

class FeedScheduleCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedScheduleCardBloc, FeedScheduleCardBlocState>(
        bloc: BlocProvider.of<FeedScheduleCardBloc>(context),
        builder: (context, state) => FeedCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FeedCardTitle('assets/feed_card/icon_schedule.svg',
                      'Schedule change', state.feedEntry),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FeedCardDate(state.feedEntry),
                  ),
                  Container(
                    height: 150,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Flipped to\n${state.params['schedule']}!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff3bb30b)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }
}
