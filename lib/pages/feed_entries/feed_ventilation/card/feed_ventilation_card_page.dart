import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_green_app/pages/feed_entries/feed_ventilation/card/feed_ventilation_card_bloc.dart';
import 'package:super_green_app/widgets/feed_card_date.dart';

//{"initialValues":{"blowerDay":40,"blowerNight":20},"values":{"blowerDay":52,"blowerNight":30}}
class FeedVentilationCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedVentilationCardBloc, FeedVentilationCardBlocState>(
        bloc: BlocProvider.of<FeedVentilationCardBloc>(context),
        builder: (context, state) => Card(
              child: Column(
                children: [
                  ListTile(
                    leading:
                        SvgPicture.asset('assets/feed_card/icon_blower.svg'),
                    title: const Text('Feed Ventilation',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: FeedCardDate(state.feedEntry),
                  ),
                  Container(
                    height: 150,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'From:',
                          style: TextStyle(fontSize: 20),
                        ),
                        _renderValues(state.params['initialValues']),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text(
                            'To:',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        _renderValues(state.params['values']),
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }

  Widget _renderValues(Map<String, dynamic> values) {
    return Text(
      'Night: ${values['blowerNight']}% Day: ${values['blowerDay']}%',
      style: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff3bb30b)),
    );
  }
}
