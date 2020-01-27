import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_schedule/form/bloc/feed_schedule_form_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';

class FeedScheduleFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: Provider.of<FeedScheduleFormBloc>(context),
      listener: (BuildContext context, FeedScheduleFormBlocState state) {
        if (state is FeedScheduleFormBlocStateDone) {
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigatorActionPop());
        }
      },
      child: BlocBuilder<FeedScheduleFormBloc, FeedScheduleFormBlocState>(
          bloc: Provider.of<FeedScheduleFormBloc>(context),
          builder: (context, state) => Scaffold(
              appBar: SGLAppBar('Add schedule'),
              body: Column(children: [
                Text('ScheduleChange'),
                RaisedButton(
                  child: Text('OK'),
                  onPressed: () =>
                      BlocProvider.of<FeedScheduleFormBloc>(context)
                          .add(FeedScheduleFormBlocEventCreate('Test')),
                ),
              ]))),
    );
  }
}
