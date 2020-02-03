import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_schedule/form/bloc/feed_schedule_form_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_param_layout.dart';
import 'package:super_green_app/widgets/green_button.dart';

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
              backgroundColor: Colors.white,
              appBar: SGLAppBar(
                'Add schedule',
              ),
              body: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView(children: [
                      this._renderSchedule(
                          context,
                          'Vegetative schedule',
                          'assets/feed_form/icon_veg.svg',
                          SGLLocalizations.of(context).vegScheduleHelper,
                          state.schedule == 'VEG', () {
                        BlocProvider.of<FeedScheduleFormBloc>(context)
                            .add(FeedScheduleFormBlocEventSetSchedule('VEG'));
                      }),
                      this._renderSchedule(
                          context,
                          'Blooming schedule',
                          'assets/feed_form/icon_bloom.svg',
                          SGLLocalizations.of(context).bloomScheduleHelper,
                          state.schedule == 'BLOOM', () {
                        BlocProvider.of<FeedScheduleFormBloc>(context)
                            .add(FeedScheduleFormBlocEventSetSchedule('BLOOM'));
                      }),
                      this._renderSchedule(
                          context,
                          'Auto flower schedule',
                          'assets/feed_form/icon_autoflower.svg',
                          SGLLocalizations.of(context).autoScheduleHelper,
                          state.schedule == 'AUTO', () {
                        BlocProvider.of<FeedScheduleFormBloc>(context)
                            .add(FeedScheduleFormBlocEventSetSchedule('AUTO'));
                      }),
                    ]),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GreenButton(
                        title: 'DONE',
                        onPressed: () =>
                            BlocProvider.of<FeedScheduleFormBloc>(context)
                                .add(FeedScheduleFormBlocEventCreate()),
                      ),
                    ),
                  ),
                ],
              ))),
    );
  }

  Widget _renderSchedule(BuildContext context, String title, String icon, String helper,
      bool selected, Function onPressed) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: FeedFormParamLayout(
        title: title,
        icon: icon,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(helper),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ButtonTheme(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                      minWidth: 0,
                      height: 0,
                      child: RaisedButton(
                        elevation: 0,
                        color: Colors.transparent,
                        child: Icon(Icons.settings),
                        onPressed: () {},
                      )),
                  GreenButton(
                    title: selected ? 'SELECTED' : 'SELECT',
                    onPressed: () {},
                    color: selected ? 0xff3bb30b : 0xff777777,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
