import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feeds/feed_entries/feed_defoliation/form/bloc/feed_defoliation_form_bloc.dart';

class FeedDefoliationFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: Provider.of<FeedDefoliationFormBloc>(context),
      listener: (BuildContext context, FeedDefoliationFormBlocState state) {
        if (state is FeedDefoliationFormBlocStateDone) {
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigatorActionPop());
        }
      },
      child: BlocBuilder<FeedDefoliationFormBloc, FeedDefoliationFormBlocState>(
          bloc: Provider.of<FeedDefoliationFormBloc>(context),
          builder: (context, state) => Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: Text(
                  'Add defoliation',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: Column(children: [
                Text('DefoliationChange',
                    style: TextStyle(color: Colors.white)),
                RaisedButton(
                  child: Text('OK'),
                  onPressed: () =>
                      BlocProvider.of<FeedDefoliationFormBloc>(context)
                          .add(FeedDefoliationFormBlocEventCreate('Test')),
                ),
              ]))),
    );
  }
}
