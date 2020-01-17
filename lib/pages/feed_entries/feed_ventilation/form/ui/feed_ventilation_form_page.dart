import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_ventilation/form/bloc/feed_ventilation_form_bloc.dart';

class FeedVentilationFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: Provider.of<FeedVentilationFormBloc>(context),
      listener: (BuildContext context, FeedVentilationFormBlocState state) {
        if (state is FeedVentilationFormBlocStateDone) {
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigatorActionPop());
        }
      },
      child: BlocBuilder<FeedVentilationFormBloc, FeedVentilationFormBlocState>(
          bloc: Provider.of<FeedVentilationFormBloc>(context),
          builder: (context, state) => Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: Text(
                  'Add ventilation change',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: Column(children: [
                Text('VentilationChange',
                    style: TextStyle(color: Colors.white)),
                RaisedButton(
                  child: Text('OK'),
                  onPressed: () =>
                      BlocProvider.of<FeedVentilationFormBloc>(context)
                          .add(FeedVentilationFormBlocEventCreate('Test')),
                ),
              ]))),
    );
  }
}
