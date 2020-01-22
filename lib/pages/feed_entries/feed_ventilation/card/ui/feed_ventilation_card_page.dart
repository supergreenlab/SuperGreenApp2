import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/pages/feed_entries/feed_ventilation/card/bloc/feed_ventilation_card_bloc.dart';

class FeedVentilationCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedVentilationCardBloc, FeedVentilationCardBlocState>(
        bloc: Provider.of<FeedVentilationCardBloc>(context),
        builder: (context, state) => Card(
                color: Color.fromARGB(40, 255, 255, 255),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.album, color: Colors.white,),
                      title: const Text('Feed Ventilation', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ));
  }
}