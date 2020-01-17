import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_water/form/bloc/feed_water_form_bloc.dart';

class FeedWaterFormPage extends StatelessWidget {
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
          builder: (context, state) => Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: Text(
                  'Add water',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: Column(children: [
                Text('Water', style: TextStyle(color: Colors.white)),
                RaisedButton(
                  child: Text('OK'),
                  onPressed: () => BlocProvider.of<FeedWaterFormBloc>(context)
                      .add(FeedWaterFormBlocEventCreate('Test')),
                ),
              ]))),
    );
  }
}
