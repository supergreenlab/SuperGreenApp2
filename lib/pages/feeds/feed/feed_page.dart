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
import 'package:super_green_app/pages/feed_entries/feed_entries.dart';
import 'package:super_green_app/pages/feeds/feed/feed_bloc.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class FeedPage extends StatelessWidget {
  final Color color;
  final String title;
  final Widget appBar;
  final double appBarHeight;

  const FeedPage(
      {this.title, @required this.color, this.appBar, this.appBarHeight});

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
    List<Widget> entries = state.entries
        .map((e) => FeedEntriesHelper.cardForFeedEntry(state.feed, e))
        .toList();
    entries.add(Container(height: 76));
    return Container(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            expandedHeight: appBarHeight ?? 200.0,
            iconTheme: IconThemeData(color: Color(0xff404040)),
            flexibleSpace: FlexibleSpaceBar(
              background: this.appBar,
              centerTitle: this.appBar == null,
              title: this.appBar == null ? Text(title, style: TextStyle(color: Color(0xff404040))) : null,
            ),
          ),
          SliverList(delegate: SliverChildListDelegate(entries))
        ],
      ),
    );
  }
}
