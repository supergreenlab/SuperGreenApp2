import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/pages/feed_entries/feed_water/card/bloc/feed_water_card_bloc.dart';

class FeedWaterCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedWaterCardBloc, FeedWaterCardBlocState>(
        bloc: Provider.of<FeedWaterCardBloc>(context),
        builder: (context, state) => Card(
                color: Color.fromARGB(40, 255, 255, 255),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.album, color: Colors.white,),
                      title: const Text('Feed Water', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ));
  }
}
