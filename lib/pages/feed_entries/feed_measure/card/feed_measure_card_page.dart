/*
 * Copyright (C) 2022  SuperGreenLab <towelie@supergreenlab.com>
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
import 'package:intl/intl.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/explorer/sections/widgets/plant_phase.dart';
import 'package:super_green_app/pages/explorer/sections/widgets/plant_strain.dart';
import 'package:super_green_app/pages/feed_entries/common/comments/card/comments_card_page.dart';
import 'package:super_green_app/pages/feed_entries/common/feed_entry_assets.dart';
import 'package:super_green_app/pages/feed_entries/common/social_bar/social_bar_page.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_measure.dart';
import 'package:super_green_app/pages/feed_entries/feed_measure/card/feed_measure_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_state.dart';
import 'package:super_green_app/widgets/feed_card/feed_card.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_date.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_text.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_title.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/media_list.dart';

class FeedMeasureCardPage extends StatefulWidget {
  static String get feedMeasureCardPageTitle {
    return Intl.message(
      'Measure',
      name: 'feedMeasureCardPageTitle',
      desc: 'Feed measure card title',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String feedMeasureCardPageDays(int days) {
    return Intl.message(
      '$days days',
      args: [days],
      name: 'feedMeasureCardPageDays',
      desc: 'Feed measure card duration in days',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String feedMeasureCardPageSeconds(int seconds) {
    return Intl.message(
      '$seconds s',
      args: [seconds],
      name: 'feedMeasureCardPageSeconds',
      desc: 'Feed measure card duration in seconds',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String feedMeasureCardPageMinutes(int seconds) {
    return Intl.message(
      '$seconds min',
      args: [seconds],
      name: 'feedMeasureCardPageMinutes',
      desc: 'Feed measure card duration in minutes',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String feedMeasureCardPageHours(int hours) {
    return Intl.message(
      '$hours hours',
      args: [hours],
      name: 'feedMeasureCardPageHours',
      desc: 'Feed measure card duration in hours',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String feedMeasureCardPageDaysAndHours(int days, int hours) {
    return Intl.message(
      '$days days and $hours hours',
      args: [days, hours],
      name: 'feedMeasureCardPageDaysAndHours',
      desc: 'Feed measure card duration in days and hours',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  final Animation<double> animation;
  final FeedState feedState;
  final FeedEntryState state;
  final List<Widget> Function(BuildContext context, FeedEntryState feedEntryState)? cardActions;

  const FeedMeasureCardPage(this.animation, this.feedState, this.state, {Key? key, this.cardActions}) : super(key: key);

  @override
  _FeedMeasureCardPageState createState() => _FeedMeasureCardPageState();
}

class _FeedMeasureCardPageState extends State<FeedMeasureCardPage> {
  bool editText = false;

  @override
  Widget build(BuildContext context) {
    if (widget.state is FeedEntryStateLoaded) {
      return _renderLoaded(context, widget.state as FeedMeasureState);
    }
    return _renderLoading(context, widget.state);
  }

  Widget _renderLoading(BuildContext context, FeedEntryState state) {
    return FeedCard(
      animation: widget.animation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FeedCardTitle(
            FeedEntryIcons[FE_MEASURE]!,
            FeedMeasureCardPage.feedMeasureCardPageTitle,
            state.synced,
            showSyncStatus: !state.isRemoteState,
            showControls: !state.isRemoteState,
            title2: widget.state.showPlantInfos ? widget.state.plantName : null,
          ),
          state.showPlantInfos
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      Expanded(child: PlantStrain(plantSettings: state.plantSettings!)),
                      Expanded(child: PlantPhase(plantSettings: state.plantSettings!, time: state.date)),
                    ],
                  ),
                )
              : Container(),
          Container(
            height: 350,
            alignment: Alignment.center,
            child: FullscreenLoading(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FeedCardDate(state, widget.feedState),
          ),
        ],
      ),
    );
  }

  Widget _renderLoaded(BuildContext context, FeedMeasureState state) {
    FeedMeasureParams params = state.params as FeedMeasureParams;
    String? sliderTitle;
    if (params.time != null) {
      Duration time = Duration(seconds: params.time!);
      sliderTitle = FeedMeasureCardPage.feedMeasureCardPageDays(Duration(seconds: params.time!).inDays);
      if (time.inMinutes == 0) {
        sliderTitle = FeedMeasureCardPage.feedMeasureCardPageSeconds(Duration(seconds: params.time!).inSeconds);
      } else if (time.inHours == 0) {
        sliderTitle = FeedMeasureCardPage.feedMeasureCardPageMinutes(Duration(seconds: params.time!).inMinutes);
      } else if (time.inDays == 0) {
        sliderTitle = FeedMeasureCardPage.feedMeasureCardPageHours(Duration(seconds: params.time!).inHours);
      } else if (time.inDays < 4) {
        sliderTitle = FeedMeasureCardPage.feedMeasureCardPageDaysAndHours(
            Duration(seconds: params.time!).inDays, Duration(seconds: params.time!).inHours % 24);
      }
    }
    return FeedCard(
      animation: widget.animation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FeedCardTitle(FeedEntryIcons[FE_MEASURE]!, FeedMeasureCardPage.feedMeasureCardPageTitle, state.synced,
              title2: widget.state.showPlantInfos ? widget.state.plantName : null,
              showSyncStatus: !state.isRemoteState,
              showControls: !state.isRemoteState, onEdit: () {
            setState(() {
              editText = true;
            });
          }, onDelete: () {
            BlocProvider.of<FeedBloc>(context).add(FeedBlocEventDeleteEntry(state));
          }, actions: widget.cardActions != null ? widget.cardActions!(context, state) : []),
          state.showPlantInfos
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      Expanded(child: PlantStrain(plantSettings: state.plantSettings!)),
                      Expanded(child: PlantPhase(plantSettings: state.plantSettings!, time: state.date)),
                    ],
                  ),
                )
              : Container(),
          MediaList(
            [state.current],
            showSyncStatus: !state.isRemoteState,
            showTapIcon: state.previous != null,
            onMediaTapped: (media) {
              if (state.previous != null) {
                BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToFullscreenMedia(
                    state.previous!.thumbnailPath, state.previous!.filePath,
                    overlayPath: state.current.filePath, heroPath: state.current.filePath, sliderTitle: sliderTitle));
              } else {
                BlocProvider.of<MainNavigatorBloc>(context)
                    .add(MainNavigateToFullscreenMedia(state.current.thumbnailPath, state.current.filePath));
              }
            },
          ),
          SocialBarPage(
            state: state,
            feedState: widget.feedState,
          ),
          (params.message ?? '') != '' || editText == true
              ? FeedCardText(
                  params.message ?? '',
                  edit: editText,
                  onEdited: (value) {
                    BlocProvider.of<FeedBloc>(context).add(FeedBlocEventEditParams(state, params.copyWith(value)));
                    setState(() {
                      editText = false;
                    });
                  },
                )
              : Container(),
          CommentsCardPage(
            state: state,
            feedState: widget.feedState,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FeedCardDate(state, widget.feedState),
          ),
        ],
      ),
    );
  }
}
