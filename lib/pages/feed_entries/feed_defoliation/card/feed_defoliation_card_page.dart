import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:super_green_app/pages/feed_entries/feed_defoliation/card/feed_defoliation_card_bloc.dart';
import 'package:super_green_app/widgets/feed_card_date.dart';
import 'package:super_green_app/widgets/media_list.dart';

class FeedDefoliationCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedDefoliationCardBloc, FeedDefoliationCardBlocState>(
        bloc: BlocProvider.of<FeedDefoliationCardBloc>(context),
        builder: (context, state) => Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    leading: SvgPicture.asset(
                        'assets/feed_card/icon_defoliation.svg'),
                    title: const Text('Feed Defoliation',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: FeedCardDate(state.feedEntry),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: MediaList(state.beforeMedias, prefix: 'Before '),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: MediaList(state.afterMedias, prefix: 'After '),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0, bottom: 16.0),
                    child: Text(
                        state.params['message'] ?? '',
                        style: TextStyle(color: Colors.black54, fontSize: 17)),
                  ),
                ],
              ),
            ));
  }
}
