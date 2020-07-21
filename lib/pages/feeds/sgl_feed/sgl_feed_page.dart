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
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/feed_page.dart';
import 'package:super_green_app/pages/feeds/sgl_feed/sgl_feed_bloc.dart';
import 'package:super_green_app/pages/feeds/sgl_feed/sgl_feed_provider.dart';

class SGLFeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SGLFeedBloc, SGLFeedBlocState>(
        bloc: BlocProvider.of<SGLFeedBloc>(context),
        builder: (BuildContext context, SGLFeedBlocState state) {
          return _renderFeed(context, state);
        },
      ),
    );
  }

  Widget _renderFeed(BuildContext context, SGLFeedBlocState state) {
    return BlocProvider(
      create: (context) => FeedBloc(SGLFeedBlocProvider(1)),
      child: FeedPage(
        title: '',
        color: Colors.indigo,
        appBarHeight: 200,
        appBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: SvgPicture.asset('assets/feed_card/logo_sgl_white.svg'),
          ),
        ),
      ),
    );
  }
}
