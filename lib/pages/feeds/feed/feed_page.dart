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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_entries_card_helpers.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_state.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:visibility_detector/visibility_detector.dart';

class FeedPage extends StatefulWidget {
  final Color color;
  final String title;
  final Widget appBar;
  final double appBarHeight;
  final bool bottomPadding;
  final List<Widget> actions;

  const FeedPage(
      {@required this.title,
      @required this.color,
      this.appBar,
      @required this.appBarHeight,
      this.bottomPadding = false,
      this.actions});

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  FeedState feedState;
  bool eof = false;
  final List<FeedEntryState> entries = [];
  final Map<dynamic, bool> visibleEntries = {};

  final ScrollController scrollController = ScrollController();
  final GlobalKey<SliverAnimatedListState> listKey =
      GlobalKey<SliverAnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedBloc, FeedBlocState>(
      listener: (BuildContext context, state) {
        if (state is FeedBlocStateFeedLoaded) {
          feedState = state.feed;
        } else if (state is FeedBlocStateEntriesLoaded) {
          setState(() {
            eof = state.eof;
            entries.addAll(state.entries);
          });
        } else if (state is FeedBlocStateAddEntry) {
          entries.insert(state.index, state.entry);
          listKey.currentState
              .insertItem(1, duration: Duration(milliseconds: 500));
          if (scrollController.offset == 0) {
            // this is to prevent a bug with animateTo not triggering when offset == 0
            scrollController.jumpTo(30);
          }
          Timer(
              Duration(milliseconds: 100),
              () => scrollController.animateTo(widget.appBarHeight - 56.0,
                  duration: Duration(milliseconds: 500), curve: Curves.linear));
        } else if (state is FeedBlocStateUpdateEntry) {
          setState(() {
            entries[state.index] = state.entry;
          });
        } else if (state is FeedBlocStateRemoveEntry) {
          FeedEntryState entry = state.entry;
          entries.removeAt(state.index);
          listKey.currentState.removeItem(
              state.index,
              (context, animation) => FeedEntriesCardHelpers.cardForFeedEntry(
                  animation, feedState, entry),
              duration: Duration(milliseconds: 500));
        }
      },
      child: BlocBuilder<FeedBloc, FeedBlocState>(
        bloc: BlocProvider.of<FeedBloc>(context),
        builder: (BuildContext context, FeedBlocState state) {
          Widget body;
          if (entries.length == 0) {
            body = FullscreenLoading(title: 'Loading feed...');
          } else {
            body = _renderCards(context);
          }
          return AnimatedSwitcher(
              child: body, duration: Duration(milliseconds: 200));
        },
      ),
    );
  }

  Widget _renderCards(BuildContext context) {
    return Container(
      color: Color(0xffeeeeee),
      child: CustomScrollView(
        controller: scrollController,
        slivers: <Widget>[
          SliverAppBar(
            actions: widget.actions,
            backgroundColor: widget.color,
            expandedHeight: widget.appBarHeight ?? 56.0,
            iconTheme: IconThemeData(color: Colors.white),
            elevation: 4,
            forceElevated: true,
            flexibleSpace: FlexibleSpaceBar(
              background: this.widget.appBar,
              centerTitle: this.widget.appBar == null,
              title: this.widget.appBar == null
                  ? Text(widget.title,
                      style: TextStyle(color: Color(0xff404040)))
                  : null,
            ),
          ),
          SliverAnimatedList(
            key: listKey,
            itemBuilder:
                (BuildContext context, int index, Animation<double> animation) {
              if (index >= entries.length) {
                return null;
              }
              FeedEntryState feedEntry = entries[index];
              Widget card = FeedEntriesCardHelpers.cardForFeedEntry(
                  animation, feedState, feedEntry);
              if (index == 0) {
                card = Padding(padding: EdgeInsets.only(top: 10), child: card);
              } else if (index == entries.length - 1 && eof) {
                card =
                    Padding(padding: EdgeInsets.only(bottom: 10), child: card);
              } else if (index == entries.length && !eof) {
                BlocProvider.of<FeedBloc>(context)
                    .add(FeedBlocEventLoadEntries(10));
                return Container(
                  height: 50,
                  child: FullscreenLoading(),
                );
              }
              return VisibilityDetector(
                  key: Key('feed_entry_${feedEntry.feedEntryID}'),
                  onVisibilityChanged: (VisibilityInfo info) {
                    if (!(visibleEntries[feedEntry.feedEntryID] ?? false) &&
                        info.visibleFraction > 0) {
                      visibleEntries[feedEntry.feedEntryID] = true;
                      BlocProvider.of<FeedBloc>(context)
                          .add(FeedBlocEventEntryVisible(index));
                      if (feedEntry.isNew && ModalRoute.of(context).isCurrent) {
                        BlocProvider.of<FeedBloc>(context)
                            .add(FeedBlocEventMarkAsRead(index));
                      }
                    }
                    if (visibleEntries[feedEntry.feedEntryID] == true &&
                        info.visibleFraction == 0) {
                      visibleEntries[feedEntry.feedEntryID] = false;
                      BlocProvider.of<FeedBloc>(context)
                          .add(FeedBlocEventEntryHidden(index));
                    }
                  },
                  child: SlideTransition(
                      position: animation.drive(Tween<Offset>(
                              begin: Offset(0.0, 1.0), end: Offset.zero)
                          .chain(CurveTween(curve: Curves.linear))),
                      child: card));
            },
            initialItemCount: entries.length + 1,
          )
        ],
      ),
    );
  }
}
