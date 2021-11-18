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
import 'package:super_green_app/data/analytics/matomo.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/bookmarks/bookmarks_bloc.dart';
import 'package:super_green_app/pages/bookmarks/bookmarks_feed_delegate.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';
import 'package:super_green_app/pages/feeds/feed/feed_page.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class BookmarksPage extends TraceableStatefulWidget {
  @override
  _BookmarksPageState createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  bool hasCards = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarksBloc, BookmarksBlocState>(
        bloc: BlocProvider.of<BookmarksBloc>(context),
        builder: (context, state) {
          Widget body = FullscreenLoading(
            title: 'Loading..',
          );
          if (state is BookmarksBlocStateInit) {
            body = FullscreenLoading();
          } else if (state is BookmarksBlocStateLoaded) {
            body = renderFeed(context);
            if (!hasCards) {
              body = Stack(
                children: [
                  body,
                  renderNoCard(context),
                ],
              );
            }
          }
          return Scaffold(
              appBar: SGLAppBar(
                'Bookmarks',
                backgroundColor: Colors.deepPurple,
                titleColor: Colors.yellow,
                iconColor: Colors.white,
                elevation: 10,
              ),
              body: body);
        });
  }

  Widget renderFeed(BuildContext context) {
    return BlocProvider(
      create: (context) => FeedBloc(BookmarksFeedBlocDelegate()),
      child: FeedPage(
        title: '',
        pinned: true,
        color: Colors.indigo,
        appBarEnabled: false,
        onLoaded: (bool hasCards) {
          setState(() {
            this.hasCards = hasCards;
          });
        },
        cardActions: (BuildContext context, FeedEntryState state) {
          return [
            IconButton(
              icon: Text(
                'Open plant',
                style: TextStyle(fontSize: 12.0, color: Color(0xff3bb30b), fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                BlocProvider.of<MainNavigatorBloc>(context)
                    .add(MainNavigateToPublicPlant(state.plantID!, feedEntryID: state.feedEntryID));
              },
            )
          ];
        },
      ),
    );
  }

  Widget renderNoCard(BuildContext context) {
    return Fullscreen(
      title: 'No bookmarks yet',
      subtitle: 'You can add important diary entries here, checkout the plant diaries to add some now!',
      child: Icon(
        Icons.bookmark,
        color: Color(0xff3bb30b),
        size: 100,
      ),
    );
  }
}
