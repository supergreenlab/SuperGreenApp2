import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_topping/form/bloc/feed_topping_form_bloc.dart';

class FeedToppingFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: Provider.of<FeedToppingFormBloc>(context),
      listener: (BuildContext context, FeedToppingFormBlocState state) {
        if (state is FeedToppingFormBlocStateDone) {
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigatorActionPop());
        }
      },
          child: BlocBuilder<FeedToppingFormBloc, FeedToppingFormBlocState>(
          bloc: Provider.of<FeedToppingFormBloc>(context),
          builder: (context, state) => Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: Text(
                  'Add topping',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: Column(children: [
                Text('ToppingChange', style: TextStyle(color: Colors.white)),
                RaisedButton(
                  child: Text('OK'),
                  onPressed: () => BlocProvider.of<FeedToppingFormBloc>(context)
                      .add(FeedToppingFormBlocEventCreate('Test')),
                ),
              ]))),
    );
  }
}
