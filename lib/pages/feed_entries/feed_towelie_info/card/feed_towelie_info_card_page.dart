import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_towelie_info/card/feed_towelie_info_card_bloc.dart';
import 'package:super_green_app/widgets/feed_card/feed_card.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_title.dart';

class FeedTowelieInfoCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedTowelieInfoCardBloc, FeedTowelieInfoCardBlocState>(
        bloc: BlocProvider.of<FeedTowelieInfoCardBloc>(context),
        builder: (context, state) => FeedCard(
              child: Column(
                children: [
                  FeedCardTitle('assets/feed_card/icon_towelie.png', 'Towelie', state.feedEntry),
                  Text(state.feedEntry.params),
                  ButtonBar(
                    alignment: MainAxisAlignment.start,
                    children: <Widget>[
                      FlatButton(
                        child: const Text('CREATE BOX',
                            style: TextStyle(color: Colors.blue)),
                        onPressed: () {
                          BlocProvider.of<MainNavigatorBloc>(context)
                              .add(MainNavigateToNewBoxInfosEvent());
                        },
                      ),
                    ],
                  )
                ],
              ),
            ));
  }
}
