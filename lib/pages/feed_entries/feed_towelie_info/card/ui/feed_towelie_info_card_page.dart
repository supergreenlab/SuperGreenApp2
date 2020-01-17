import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_towelie_info/card/bloc/feed_towelie_card_bloc.dart';

class FeedTowelieInfoCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedTowelieInfoCardBloc, FeedTowelieInfoCardBlocState>(
        bloc: Provider.of<FeedTowelieInfoCardBloc>(context),
        builder: (context, state) => Card(
              color: Color.fromARGB(40, 255, 255, 255),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.album,
                      color: Colors.white,
                    ),
                    title: const Text('Feed',
                        style: TextStyle(color: Colors.white)),
                    subtitle: Text(state.feedEntry.date.toIso8601String(),
                        style: TextStyle(color: Colors.white)),
                  ),
                  Text(state.feedEntry.params, style: TextStyle(color: Colors.white)),
                  ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: const Text('CREATE BOX',
                            style: TextStyle(color: Color(0xFF3BB30B))),
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
