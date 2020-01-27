import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/pages/feed_entries/feed_water/card/bloc/feed_water_card_bloc.dart';

class FeedWaterCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedWaterCardBloc, FeedWaterCardBlocState>(
        bloc: Provider.of<FeedWaterCardBloc>(context),
        builder: (context, state) => Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: SvgPicture.asset('assets/feed_card/watering.svg'),
                      title: const Text('Feed Water', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(state.feedEntry.date.toIso8601String(),
                        style: TextStyle(color: Colors.black54)),
                    ),
                  ],
                ),
              ));
  }
}
