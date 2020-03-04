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
import 'package:super_green_app/pages/feed_entries/feed_entries.dart';
import 'package:super_green_app/pages/feeds/feed/feed_bloc.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class FeedPage extends StatefulWidget {
  final Color color;
  final String title;
  final Widget appBar;
  final double appBarHeight;

  const FeedPage(
      {@required this.title, @required this.color, this.appBar, @required this.appBarHeight});

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  int _nEntries = -1;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBloc, FeedBlocState>(
      bloc: BlocProvider.of<FeedBloc>(context),
      builder: (BuildContext context, FeedBlocState state) {
        if (state is FeedBlocStateLoaded) {
          return _renderCards(context, state);
        }
        return FullscreenLoading(title: 'Loading feed...');
      },
    );
  }

  Widget _renderCards(BuildContext context, FeedBlocStateLoaded state) {
    int i = 0;
    List<Widget> entries = state.entries.map((e) {
      bool hasNewEntry =
          _nEntries != -1 && _nEntries != state.entries.length && i++ == 0;
      _nEntries = state.entries.length;
      if (hasNewEntry) {
        Timer(Duration(milliseconds: 1), () {
          if (_scrollController.offset > widget.appBarHeight) {
            return;
          }
          _scrollController.animateTo(
            widget.appBarHeight,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 800),
          );
        });
      }
      return FeedEntriesHelper.cardForFeedEntry(state.feed, e, hasNewEntry);
    }).toList();
    entries.add(Container(height: 76));
    return Container(
      child: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            expandedHeight: widget.appBarHeight ?? 56.0,
            iconTheme: IconThemeData(color: Color(0xff404040)),
            flexibleSpace: FlexibleSpaceBar(
              background: this.widget.appBar,
              centerTitle: this.widget.appBar == null,
              title: this.widget.appBar == null
                  ? Text(widget.title,
                      style: TextStyle(color: Color(0xff404040)))
                  : null,
            ),
          ),
          SliverList(delegate: SliverChildListDelegate(entries))
        ],
      ),
    );
  }
}
