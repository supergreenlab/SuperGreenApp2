import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';

class FeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBloc, FeedBlocState>(
      bloc: Provider.of<FeedBloc>(context),
      builder: (BuildContext context, FeedBlocState state) {
        if (state is FeedBlocStateLoaded) {
          return Column(
            children: [
              Text('FeedPage ${state.feed.name} ${state.feed.id}'),
              Expanded(child: _renderCards(context, state)),
            ],
          );
        }
        return Text('FeedPage loading');
      },
    );
  }

  Widget _renderCards(BuildContext context, FeedBlocStateLoaded state) {
    return ListView(
      children: state.entries
          .map((e) => Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.album),
                      title: Text('Feed'),
                      subtitle: Text(e.date.toIso8601String()),
                    ),
                    Text(e.params),
                    ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('CREATE BOX'),
                          onPressed: () {
                            BlocProvider.of<MainNavigatorBloc>(context)
                                .add(MainNavigateToNewBoxInfosEvent());
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ))
          .toList(),
    );
  }
}
