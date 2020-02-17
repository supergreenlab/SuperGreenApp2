import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_water/card/feed_water_card_bloc.dart';
import 'package:super_green_app/widgets/feed_card/feed_card.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_date.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_title.dart';

class FeedWaterCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedWaterCardBloc, FeedWaterCardBlocState>(
        bloc: BlocProvider.of<FeedWaterCardBloc>(context),
        builder: (context, state) => FeedCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FeedCardTitle('assets/feed_card/icon_watering.svg',
                      'Watering', state.feedEntry),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FeedCardDate(state.feedEntry),
                  ),
                  Container(
                    height: 150,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '${state.params['volume']}L',
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff3bb30b)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Dried: ${state.params['tooDry'] ? 'yes' : 'no'}',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Nutes: ${state.params['nutrient'] ? 'yes' : 'no'}',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }
}
