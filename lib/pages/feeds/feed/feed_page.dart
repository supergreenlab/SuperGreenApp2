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
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/feed_entries/feed_entries.dart';
import 'package:super_green_app/pages/feeds/feed/feed_bloc.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

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
  List<FeedEntry> _entries;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedBloc, FeedBlocState>(
      listener: (BuildContext context, state) {
        if (state is FeedBlocStateLoaded) {
          if (_entries != null) {
            if (state.entries.length > _entries.length) {
              int millis = min(
                  1000,
                  max(
                      600,
                      ((widget.appBarHeight - 56.0) - _scrollController.offset)
                              .abs()
                              .toInt() *
                          7));
              _entries = state.entries;
              _listKey.currentState
                  .insertItem(0, duration: Duration(milliseconds: millis));
              if (_scrollController.offset == 0) {
                // this is to prevent a bug with animateTo not triggering when offset == 0
                _scrollController.jumpTo(30);
              }

              Timer(
                  Duration(milliseconds: 100),
                  () => _scrollController.animateTo(widget.appBarHeight - 56.0,
                      duration: Duration(milliseconds: millis),
                      curve: ElasticInOutCurve()));
            } else if (state.entries.length < _entries.length) {
              for (int i = 0; i < _entries.length; ++i) {
                if (!state.entries.contains(_entries[i])) {
                  _entries = state.entries;
                  _listKey.currentState.removeItem(
                      i,
                      (context, animation) =>
                          FeedEntriesHelper.cardForFeedEntry(
                              state.feed, _entries[i], animation),
                      duration: Duration(milliseconds: 500));
                  break;
                }
              }
            }
          }
          _entries = state.entries;
        }
      },
      child: BlocBuilder<FeedBloc, FeedBlocState>(
        bloc: BlocProvider.of<FeedBloc>(context),
        builder: (BuildContext context, FeedBlocState state) {
          Widget body;
          if (state is FeedBlocStateLoaded) {
            body = _renderCards(context, state);
          } else {
            body = FullscreenLoading(title: 'Loading feed...');
          }
          return AnimatedSwitcher(
              child: body, duration: Duration(milliseconds: 200));
        },
      ),
    );
  }

  Widget _renderCards(BuildContext context, FeedBlocStateLoaded state) {
    List<FeedEntry> entries = _entries == null ? state.entries : _entries;
    return Container(
      color: Color(0xffeeeeee),
      child: CustomScrollView(
        controller: _scrollController,
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
            key: _listKey,
            itemBuilder:
                (BuildContext context, int index, Animation<double> animation) {
              index = index - 1;
              if (index == -1) {
                return Container(height: 10);
              } else if (!widget.bottomPadding && index >= entries.length) {
                return null;
              } else if (index == entries.length) {
                return Container(height: 76);
              } else if (index > entries.length) {
                return null;
              }
              if (entries[index].isNew && ModalRoute.of(context).isCurrent) {
                BlocProvider.of<FeedBloc>(context)
                    .add(FeedBlocEventMarkAsRead(entries[index]));
              }
              return SlideTransition(
                  position: animation.drive(
                      Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero)
                          .chain(CurveTween(curve: Curves.linear))),
                  child: FeedEntriesHelper.cardForFeedEntry(
                      state.feed, entries[index], animation));
            },
            initialItemCount: entries.length + 1,
          )
        ],
      ),
    );
  }
}
