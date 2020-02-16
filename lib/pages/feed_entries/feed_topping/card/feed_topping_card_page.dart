import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:super_green_app/pages/feed_entries/feed_topping/card/feed_topping_card_bloc.dart';
import 'package:super_green_app/widgets/feed_card_date.dart';

class FeedToppingCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedToppingCardBloc, FeedToppingCardBlocState>(
        bloc: BlocProvider.of<FeedToppingCardBloc>(context),
        builder: (context, state) => Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: SvgPicture.asset('assets/feed_card/icon_topping.svg'),
                      title: const Text('Feed Topping', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: FeedCardDate(state.feedEntry),
                    ),
                  ],
                ),
              ));
  }
}
