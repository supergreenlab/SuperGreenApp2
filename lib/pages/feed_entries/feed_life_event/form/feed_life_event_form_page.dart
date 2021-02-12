/*
 * Copyright (C) 2018  SuperGreenLab <towelie@supergreenlab.com>
 * Author: Constantin Clauzel <constantin.clauzel@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_life_event/form/feed_life_event_form_bloc.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_layout.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_param_layout.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:tuple/tuple.dart';

List<Tuple2<String, String>> phasesTitles = [
  Tuple2(
      FeedLifeEventFormPage.feedLifeEventFormPagePhaseLabelGermination, 'assets/plant_infos/icon_germination_date.svg'),
  Tuple2(FeedLifeEventFormPage.feedLifeEventFormPagePhaseLabelVegging, 'assets/plant_infos/icon_vegging_since.svg'),
  Tuple2(FeedLifeEventFormPage.feedLifeEventFormPagePhaseLabelBlooming, 'assets/plant_infos/icon_blooming_since.svg'),
  Tuple2(FeedLifeEventFormPage.feedLifeEventFormPagePhaseLabelDrying, 'assets/plant_infos/icon_drying_since.svg'),
  Tuple2(FeedLifeEventFormPage.feedLifeEventFormPagePhaseLabelCuring, 'assets/plant_infos/icon_curing_since.svg'),
];

class FeedLifeEventFormPage extends StatefulWidget {
  static String get feedLifeEventFormPagePhaseLabelGermination {
    return Intl.message(
      'Germination date',
      name: 'feedLifeEventFormPagePhaseLabelGermination',
      desc: 'Life event germination label',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get feedLifeEventFormPagePhaseLabelVegging {
    return Intl.message(
      'Vegging since',
      name: 'feedLifeEventFormPagePhaseLabelVegging',
      desc: 'Life event vegging label',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get feedLifeEventFormPagePhaseLabelBlooming {
    return Intl.message(
      'Blooming since',
      name: 'feedLifeEventFormPagePhaseLabelBlooming',
      desc: 'Life event blooming label',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get feedLifeEventFormPagePhaseLabelDrying {
    return Intl.message(
      'Drying since',
      name: 'feedLifeEventFormPagePhaseLabelDrying',
      desc: 'Life event drying label',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get feedLifeEventFormPagePhaseLabelCuring {
    return Intl.message(
      'Curing since',
      name: 'feedLifeEventFormPagePhaseLabelCuring',
      desc: 'Life event curing label',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get feedLifeEventFormPagePhaseLabel {
    return Intl.message(
      'Phase',
      name: 'feedLifeEventFormPagePhaseLabel',
      desc: 'Label for phase',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get feedLifeEventFormPageChangeButton {
    return Intl.message(
      'change',
      name: 'feedLifeEventFormPageChangeButton',
      desc: '"Change" button label',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get feedLifeEventFormPageNotSet {
    return Intl.message(
      'Not set',
      name: 'feedLifeEventFormPageNotSet',
      desc: 'Displayed when date is not set yet',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get feedLifeEventFormPageSetButton {
    return Intl.message(
      'set',
      name: 'feedLifeEventFormPageSetButton',
      desc: '"Set" button label',
      locale: SGLLocalizations.current.localeName,
    );
  }

  @override
  _FeedLifeEventFormPageState createState() => _FeedLifeEventFormPageState();
}

class _FeedLifeEventFormPageState extends State<FeedLifeEventFormPage> {
  DateTime date;

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedLifeEventFormBloc, FeedLifeEventFormBlocState>(
      listener: (BuildContext context, state) {
        if (state is FeedLifeEventFormBlocStateLoaded) {
          setState(() {
            date = state.date ?? DateTime.now();
          });
        } else if (state is FeedLifeEventFormBlocStateDone) {
          BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop(mustPop: true));
        }
      },
      child: BlocBuilder<FeedLifeEventFormBloc, FeedLifeEventFormBlocState>(
          cubit: BlocProvider.of<FeedLifeEventFormBloc>(context),
          builder: (context, state) {
            Widget body;
            Tuple2<String, String> phaseTitle = Tuple2(
                FeedLifeEventFormPage.feedLifeEventFormPagePhaseLabel, 'assets/plant_infos/icon_germination_date.svg');
            if (state is FeedLifeEventFormBlocStateInit || state is FeedLifeEventFormBlocStateDone) {
              body = Expanded(child: FullscreenLoading());
            } else if (state is FeedLifeEventFormBlocStateLoaded) {
              body = renderForm(context, state);
              phaseTitle = phasesTitles[state.phase.index];
            }
            return FeedFormLayout(
              title: '🎉',
              fontSize: 35,
              topBarPadding: 0,
              onOK: () {
                BlocProvider.of<FeedLifeEventFormBloc>(context).add(FeedLifeEventFormBlocEventSetDate(date));
              },
              body: Column(
                children: [
                  FeedFormParamLayout(title: phaseTitle.item1, icon: phaseTitle.item2, child: body),
                ],
              ),
            );
          }),
    );
  }

  Widget renderForm(BuildContext context, FeedLifeEventFormBlocStateLoaded state) {
    String text;
    String buttonText;
    if (date != null) {
      String format = AppDB().getAppData().freedomUnits ? 'MM/dd/yyyy' : 'dd/MM/yyyy';
      DateFormat f = DateFormat(format);
      text = f.format(date);
      buttonText = FeedLifeEventFormPage.feedLifeEventFormPageChangeButton;
    } else {
      text = FeedLifeEventFormPage.feedLifeEventFormPageNotSet;
      buttonText = FeedLifeEventFormPage.feedLifeEventFormPageSetButton;
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SvgPicture.asset('assets/feed_form/icon_calendar.svg', width: 50, height: 50),
          Text(
            text,
            style: TextStyle(fontSize: 20, color: Colors.grey.shade700),
          ),
          FlatButton(
            onPressed: () async {
              DateTime newDate = await showDatePicker(
                  context: context,
                  initialDate: date,
                  firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                  lastDate: DateTime.now());
              if (newDate == null) {
                return;
              }
              setState(() {
                date = newDate;
              });
            },
            child: Text(buttonText, style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}
