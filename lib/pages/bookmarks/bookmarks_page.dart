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
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/bookmarks/bookmarks_bloc.dart';
import 'package:super_green_app/pages/bookmarks/bookmarks_feed_delegate.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';
import 'package:super_green_app/pages/feeds/feed/feed_page.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class BookmarksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarksBloc, BookmarksBlocState>(
        cubit: BlocProvider.of<BookmarksBloc>(context),
        builder: (context, state) {
          Widget body;
          if (state is BookmarksBlocStateInit) {
            body = FullscreenLoading();
          } else if (state is BookmarksBlocStateLoaded) {
            body = renderFeed(context);
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
        cardActions: (FeedEntryState state) {
          return [
            IconButton(
              icon: Icon(
                Icons.open_in_browser,
                color: Colors.grey,
              ),
              onPressed: () {
                BlocProvider.of<MainNavigatorBloc>(context).add(
                    MainNavigateToPublicPlant(state.data['plantID'],
                        feedEntryID: state.feedEntryID));
              },
            )
          ];
        },
      ),
    );
  }
}
