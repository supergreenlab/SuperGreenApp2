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
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/explorer/models/plants.dart';
import 'package:super_green_app/pages/explorer/search/search_bloc.dart';
import 'package:super_green_app/pages/explorer/sections/widgets/plant_phase.dart';
import 'package:super_green_app/pages/explorer/sections/widgets/plant_strain.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class SearchPage extends StatefulWidget {
  final Function requestUnfocus;

  const SearchPage({Key? key, required this.requestUnfocus}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ScrollController scrollController = ScrollController();

  List<PublicPlant> plants = [];

  @override
  void initState() {
    scrollController.addListener(() {
      widget.requestUnfocus();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchBloc, SearchBlocState>(
      listener: (BuildContext context, SearchBlocState state) {
        if (state is SearchBlocStateLoaded) {
          setState(() {
            if (state.offset == 0) {
              plants.clear();
              if (scrollController.hasClients) {
                scrollController.animateTo(
                  0,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.linear,
                );
              }
            }
            plants.addAll(state.plants);
          });
        }
      },
      child: BlocBuilder<SearchBloc, SearchBlocState>(buildWhen: (SearchBlocState state1, SearchBlocState state2) {
        return !(state2 is SearchBlocStateLoading);
      }, builder: (BuildContext context, SearchBlocState state) {
        if (state is SearchBlocStateInit) {
          return FullscreenLoading();
        }
        return renderLoaded(context, state as SearchBlocStateLoaded);
      }),
    );
  }

  Widget renderLoaded(BuildContext context, SearchBlocStateLoaded state) {
    return Padding(
      padding: const EdgeInsets.only(top: 56.0),
      child: ListView.separated(
          controller: scrollController,
          itemCount: plants.length + (state.eof ? 0 : 1),
          itemBuilder: (BuildContext context, int index) {
            if (index >= plants.length && !state.eof) {
              BlocProvider.of<SearchBloc>(context).add(SearchBlocEventSearch(state.search!, plants.length));
              return Container(
                height: 120,
                child: FullscreenLoading(),
              );
            }
            PublicPlant plant = plants[index];
            return InkWell(
              onTap: () {
                BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToPublicPlant(
                  plant.id,
                  name: plant.name,
                ));
              },
              child: Container(
                height: 120,
                child: Row(
                  children: [
                    Image.network(BackendAPI().feedsAPI.absoluteFileURL(plant.thumbnailPath!),
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        headers: {'Host': BackendAPI().storageServerHostHeader},
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return FullscreenLoading(
                          percent: loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!);
                    }),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              plant.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff454545),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  PlantStrain(plantSettings: plant.settings),
                                  PlantPhase(plantSettings: plant.settings),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => Divider()),
    );
  }
}
