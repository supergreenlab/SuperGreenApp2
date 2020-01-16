import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feeds/feed_entries/feed_light/form/bloc/feed_light_form_bloc.dart';

class FeedLightFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: Provider.of<FeedLightFormBloc>(context),
      listener: (BuildContext context, FeedLightFormBlocState state) {
        if (state is FeedLightFormBlocStateDone) {
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigatorActionPop());
        }
      },
          child: BlocBuilder<FeedLightFormBloc, FeedLightFormBlocState>(
          bloc: Provider.of<FeedLightFormBloc>(context),
          builder: (context, state) => Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: Text(
                  'Add light change',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: Column(children: [
                Text('LightChange', style: TextStyle(color: Colors.white)),
                RaisedButton(
                  child: Text('OK'),
                  onPressed: () => BlocProvider.of<FeedLightFormBloc>(context)
                      .add(FeedLightFormBlocEventCreate('Test')),
                ),
              ]))),
    );
  }
}
