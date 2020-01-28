import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
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
              appBar: SGLAppBar(
                'Add schedule',
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        this._renderSchedule('Vegetative schedule',
                            'assets/feed_form/icon_veg.svg', true, () {}),
                        this._renderSchedule('Blooming schedule',
                            'assets/feed_form/icon_bloom.svg', false, () {}),
                        this._renderSchedule(
                            'Auto flower schedule',
                            'assets/feed_form/icon_autoflower.svg',
                            false,
                            () {}),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GreenButton(
                      title: 'DONE',
                      onPressed: () =>
                          BlocProvider.of<FeedScheduleFormBloc>(context)
                              .add(FeedScheduleFormBlocEventCreate('Test')),
                    ),
                  ),
                ]),
              ))),
    );
  }

  Widget _renderSchedule(
      String title, String icon, bool selected, Function onPressed) {
    return FeedFormParamLayout(
      title: title,
      icon: icon,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('pouet'),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ButtonTheme(
                  padding: EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 4.0),
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
    );
  }
}
