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
import 'package:super_green_app/pages/explorer/models/plants.dart';
import 'package:super_green_app/pages/explorer/search/search_bloc.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<PublicPlant> plants = [];

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchBloc, SearchBlocState>(
      listener: (BuildContext context, SearchBlocState state) {
        if (state is SearchBlocStateLoaded) {
          setState(() {
            plants.addAll(state.plants);
          });
        }
      },
      child: BlocBuilder<SearchBloc, SearchBlocState>(builder: (BuildContext context, SearchBlocState state) {
        if (state is SearchBlocStateInit) {
          return FullscreenLoading();
        }
        return renderLoaded(context, state);
      }),
    );
  }

  Widget renderLoaded(BuildContext context, SearchBlocStateLoaded state) {
    return ListView.separated(
        itemCount: plants.length + (state.eof ? 0 : 1),
        itemBuilder: (BuildContext context, int index) {
          if (index >= plants.length && !state.eof) {
            BlocProvider.of<SearchBloc>(context).add(SearchBlocEventSearch(state.search, plants.length));
            return Container(
              height: 50,
              child: FullscreenLoading(),
            );
          }
          return Container(
              height: 50,
              child: Row(
                children: [Text(plants[index].name)],
              ));
        },
        separatorBuilder: (BuildContext context, int index) => Divider());
  }
}
