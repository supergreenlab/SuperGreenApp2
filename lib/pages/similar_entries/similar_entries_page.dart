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
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/feed_page.dart';
import 'package:super_green_app/pages/similar_entries/similar_entries_bloc.dart';
import 'package:super_green_app/pages/similar_entries/similar_entries_feed_delegate.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class SimilarEntriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SimilarEntriesBloc, SimilarEntriesBlocState>(
        bloc: BlocProvider.of<SimilarEntriesBloc>(context),
        builder: (context, state) {
          late Widget body;

          if (state is SimilarEntriesBlocStateInit) {
            body = renderLoading(context, state);
          } else if (state is SimilarEntriesBlocStateLoaded) {
            body = renderLoaded(context, state);
          }
          return Scaffold(
            appBar: SGLAppBar(
              'Similar plants',
              backgroundColor: Colors.purple,
              titleColor: Colors.white,
              iconColor: Colors.white,
              elevation: 10,
            ),
            body: body,
          );
        });
  }

  Widget renderLoading(BuildContext context, SimilarEntriesBlocState state) {
    return FullscreenLoading();
  }

  Widget renderLoaded(BuildContext context, SimilarEntriesBlocStateLoaded state) {
    return BlocProvider(
        create: (context) => FeedBloc(SimilarEntriesFeedBlocDelegate(state.feedEntryState)),
        child: FeedPage(
          title: '',
          color: Colors.white,
          feedColor: Colors.white,
          elevate: false,
          appBarEnabled: false,
        ));
  }
}
