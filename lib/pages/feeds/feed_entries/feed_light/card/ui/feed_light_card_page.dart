import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feeds/feed_entries/feed_light/form/bloc/feed_light_form_bloc.dart';

class FeedLightFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedLightFormBloc, FeedLightFormBlocState>(
        bloc: Provider.of<FeedLightFormBloc>(context),
        builder: (context, state) => Card(
                color: Color.fromARGB(40, 255, 255, 255),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.album, color: Colors.white,),
                      title: const Text('Feed', style: TextStyle(color: Colors.white)),
                    ),
                    Text('', style: TextStyle(color: Colors.white)),
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
              ));
  }
}
