import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/pages/feed_entries/feed_topping/card/bloc/feed_topping_card_bloc.dart';

class FeedToppingCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedToppingCardBloc, FeedToppingCardBlocState>(
        bloc: Provider.of<FeedToppingCardBloc>(context),
        builder: (context, state) => Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.album),
                      title: const Text('Feed Topping', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ));
  }
}
