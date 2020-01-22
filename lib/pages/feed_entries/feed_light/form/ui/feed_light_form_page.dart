import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_light/form/bloc/feed_light_form_bloc.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_layout.dart';
import 'package:super_green_app/widgets/feed_form/slider_form_param.dart';

class FeedLightFormPage extends StatefulWidget {
  @override
  _FeedLightFormPageState createState() => _FeedLightFormPageState();
}

class _FeedLightFormPageState extends State<FeedLightFormPage> {
  List<double> values = List();

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: Provider.of<FeedLightFormBloc>(context),
      listener: (BuildContext context, FeedLightFormBlocState state) {
        if (state is FeedLightFormBlocStateLightsLoaded) {
          setState(() => values = List.from(state.values));
        } else if (state is FeedLightFormBlocStateDone) {
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigatorActionPop());
        }
      },
      child: BlocBuilder<FeedLightFormBloc, FeedLightFormBlocState>(
          bloc: Provider.of<FeedLightFormBloc>(context),
          builder: (context, state) => FeedFormLayout(
                title: 'Record creation',
                buttonTitle: 'ADD RECORD',
                onOK: () {
                  BlocProvider.of<FeedLightFormBloc>(context).add(FeedLightFormBlocEventCreate(values));
                },
                body: ListView.builder(
                  itemCount: values.length,
                  itemBuilder: (context, i) {
                    return _renderLightParam(context, i);
                  },
                ),
              )),
    );
  }

  Widget _renderLightParam(BuildContext context, int i) {
    return SliderFormParam(
      key: Key('$i'),
      title: 'Light ${i+1}',
      icon: 'assets/feed_form/icon_${values[i] > 30 ? "sun" : "moon"}.svg',
      value: values[i],
      color: _color(values[i]),
      onChanged: (double newValue) {
        setState(() {
          values[i] = newValue;
        });
      },
      onChangeEnd: (double value) {
        BlocProvider.of<FeedLightFormBloc>(context).add(FeedLightFormBlocValueChangedEvent(i, value));
      },
    );
  }

  Color _color(double value) {
    if (value > 60) {
      return Colors.yellow;
    } else if (value > 30) {
      return Colors.orange;
    }
    return Colors.blue;
  }
}
