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
                color: Color.fromARGB(40, 255, 255, 255),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.album, color: Colors.white,),
                      title: const Text('Feed Topping', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ));
  }
}
