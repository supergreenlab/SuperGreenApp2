import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:super_green_app/pages/feed_entries/feed_schedule/card/feed_schedule_card_bloc.dart';
import 'package:super_green_app/widgets/feed_card_date.dart';

class FeedScheduleCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedScheduleCardBloc, FeedScheduleCardBlocState>(
        bloc: BlocProvider.of<FeedScheduleCardBloc>(context),
        builder: (context, state) => Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: SvgPicture.asset('assets/feed_card/icon_schedule.svg'),
                      title: const Text('Feed Schedule', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: FeedCardDate(state.feedEntry),
                    ),
                  ],
                ),
              ));
  }
}
