import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_towelie_info/card/bloc/feed_towelie_info_card_bloc.dart';

class FeedTowelieInfoCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedTowelieInfoCardBloc, FeedTowelieInfoCardBlocState>(
        bloc: Provider.of<FeedTowelieInfoCardBloc>(context),
        builder: (context, state) => Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.album,
                    ),
                    title: const Text('Feed', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(state.feedEntry.date.toIso8601String()),
                  ),
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
