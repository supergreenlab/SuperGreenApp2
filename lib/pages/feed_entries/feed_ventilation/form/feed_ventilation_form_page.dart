import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_ventilation/form/feed_ventilation_form_bloc.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_layout.dart';
import 'package:super_green_app/widgets/feed_form/slider_form_param.dart';

class FeedVentilationFormPage extends StatefulWidget {
  @override
  _FeedVentilationFormPageState createState() =>
      _FeedVentilationFormPageState();
}

class _FeedVentilationFormPageState extends State<FeedVentilationFormPage> {
  int _blowerDay = 0;
  int _blowerNight = 0;

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: BlocProvider.of<FeedVentilationFormBloc>(context),
      listener: (BuildContext context, FeedVentilationFormBlocState state) {
        if (state is FeedVentilationFormBlocStateVentilationLoaded) {
          setState(() {
            _blowerDay = state.blowerDay;
            _blowerNight = state.blowerNight;
          });
        } else if (state is FeedVentilationFormBlocStateDone) {
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigatorActionPop(mustPop: true));
        }
      },
      child: BlocBuilder<FeedVentilationFormBloc, FeedVentilationFormBlocState>(
          bloc: BlocProvider.of<FeedVentilationFormBloc>(context),
          builder: (context, state) => FeedFormLayout(
                title: 'Record creation',
                changed: state is FeedVentilationFormBlocStateVentilationLoaded && (state.blowerDay != state.initialBlowerDay || state.blowerNight != state.initialBlowerNight),
                valid: state is FeedVentilationFormBlocStateVentilationLoaded && (state.blowerDay != state.initialBlowerDay || state.blowerNight != state.initialBlowerNight),
                onOK: () {
                  BlocProvider.of<FeedVentilationFormBloc>(context)
                      .add(FeedVentilationFormBlocEventCreate(_blowerDay, _blowerNight));
                },
                body: ListView(
                  children: [
                    SliderFormParam(
                      key: Key('day'),
                      title: 'Blower day',
                      icon: 'assets/feed_form/icon_blower.svg',
                      value: _blowerDay.toDouble(),
                      color: Colors.yellow,
                      onChanged: (double newValue) {
                        setState(() {
                          _blowerDay = newValue.toInt();
                        });
                      },
                      onChangeEnd: (double newValue) {
                        BlocProvider.of<FeedVentilationFormBloc>(context).add(
                            FeedVentilationFormBlocBlowerDayChangedEvent(
                                newValue.toInt()));
                      },
                    ),
                    SliderFormParam(
                      key: Key('night'),
                      title: 'Blower night',
                      icon: 'assets/feed_form/icon_blower.svg',
                      value: _blowerNight.toDouble(),
                      color: Colors.blue,
                      onChanged: (double newValue) {
                        setState(() {
                          _blowerNight = newValue.toInt();
                        });
                      },
                      onChangeEnd: (double newValue) {
                        BlocProvider.of<FeedVentilationFormBloc>(context).add(
                            FeedVentilationFormBlocBlowerNightChangedEvent(
                                newValue.toInt()));
                      },
                    ),
                  ],
                ),
              )),
    );
  }
}
