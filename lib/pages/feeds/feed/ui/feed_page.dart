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
          return _renderCards(context, state);
        }
        return Text('FeedPage loading');
      },
    );
  }

  Widget _renderCards(BuildContext context, FeedBlocStateLoaded state) {
    return ListView(
      children: state.entries
          .map((e) => Card(
                color: Color.fromARGB(40, 255, 255, 255),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.album, color: Colors.white,),
                      title: const Text('Feed', style: TextStyle(color: Colors.white)),
                      subtitle: Text(e.date.toIso8601String(), style: TextStyle(color: Colors.white)),
                    ),
                    Text(e.params, style: TextStyle(color: Colors.white)),
                    ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('CREATE BOX', style: TextStyle(color: Color(0xFF3BB30B))),
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
