import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/pages/feed_entries/feed_defoliation/card/bloc/feed_defoliation_card_bloc.dart';

class FeedDefoliationCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedDefoliationCardBloc, FeedDefoliationCardBlocState>(
        bloc: Provider.of<FeedDefoliationCardBloc>(context),
        builder: (context, state) => Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: SvgPicture.asset('assets/feed_card/icon_defoliation.svg'),
                      title: const Text('Feed Defoliation', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ));
  }
}
