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
import 'package:super_green_app/pages/feeds/feed/bloc/remote/remote_feed_provider.dart';
import 'package:super_green_app/pages/feeds/feed/feed_page.dart';
import 'package:super_green_app/pages/feeds/public_plant/public_plant_bloc.dart';

class PublicPlantPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PublicPlantBloc, PublicPlantBlocState>(
        bloc: BlocProvider.of<PublicPlantBloc>(context),
        builder: (BuildContext context, PublicPlantBlocState state) {
          return _renderFeed(context, state);
        },
      ),
    );
  }

  Widget _renderFeed(BuildContext context, PublicPlantBlocState state) {
    return BlocProvider(
      create: (context) => FeedBloc(
          RemoteFeedBlocProvider(state.id)),
      child: FeedPage(
        title: 'Plop',
        color: Colors.indigo,
        appBarHeight: 200,
        appBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child:
                SvgPicture.asset('assets/feed_card/logo_sgl_white.svg'),
          ),
        ),
      ),
    );
  }
}
