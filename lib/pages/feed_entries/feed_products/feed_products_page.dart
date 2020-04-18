import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_products/feed_products_bloc.dart';
import 'package:super_green_app/widgets/feed_card/feed_card.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_date.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_title.dart';

class FeedProductsPage extends StatefulWidget {
  final Animation animation;

  const FeedProductsPage(this.animation, {Key key}) : super(key: key);

  @override
  _FeedProductsPageState createState() => _FeedProductsPageState();
}

class _FeedProductsPageState extends State<FeedProductsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedProductsBloc, FeedProductsBlocState>(
        bloc: BlocProvider.of<FeedProductsBloc>(context),
        builder: (context, state) {
          return FeedCard(
            animation: widget.animation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FeedCardTitle(
                  'assets/feed_card/icon_media.svg',
                  'Products',
                  state.feedEntry,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: FeedCardDate(state.feedEntry),
                ),
              ],
            ),
          );
        });
  }
}
