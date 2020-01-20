import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_water/form/bloc/feed_water_form_bloc.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_layout.dart';
import 'package:super_green_app/widgets/feed_form/number_form_param.dart';
import 'package:super_green_app/widgets/feed_form/yesno_form_param.dart';

class FeedWaterFormPage extends StatefulWidget {
  @override
  _FeedWaterFormPageState createState() => _FeedWaterFormPageState();
}

class _FeedWaterFormPageState extends State<FeedWaterFormPage> {
  bool tooDry;
  double volume = 1;
  bool nutrient;

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: Provider.of<FeedWaterFormBloc>(context),
        listener: (BuildContext context, FeedWaterFormBlocState state) {
          if (state is FeedWaterFormBlocStateDone) {
            BlocProvider.of<MainNavigatorBloc>(context)
                .add(MainNavigatorActionPop());
          }
        },
        child: BlocBuilder<FeedWaterFormBloc, FeedWaterFormBlocState>(
          bloc: Provider.of<FeedWaterFormBloc>(context),
          builder: (context, state) => FeedFormLayout(
            title: 'New watering record',
            buttonTitle: 'ADD RECORD',
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  YesNoFormParam(
                      icon: 'assets/feed_form/icon_dry.svg',
                      title: 'Was it too dry?',
                      yes: tooDry,
                      onPressed: (yes) {
                        setState(() {
                          tooDry = yes;
                        });
                      }),
                  NumberFormParam(
                      icon: 'assets/feed_form/icon_volume.svg',
                      title: 'Approx. volume',
                      value: volume,
                      unit: 'L',
                      onChange: (newValue) {
                        setState(() {
                          if (newValue > 0) {
                            volume = newValue;
                          }
                        });
                      }),
                  YesNoFormParam(
                      icon: 'assets/feed_form/icon_nutrient.svg',
                      title: 'Nutrient?',
                      yes: nutrient,
                      onPressed: (yes) {
                        setState(() {
                          nutrient = yes;
                        });
                      }),
                ],
              ),
            ),
            onOK: () => BlocProvider.of<FeedWaterFormBloc>(context).add(
              FeedWaterFormBlocEventCreate('Test'),
            ),
          ),
        ));
  }
}
