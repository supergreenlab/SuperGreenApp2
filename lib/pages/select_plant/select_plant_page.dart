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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/select_plant/select_plant_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';

// TODO DRY with SettingsPlantsPage
class SelectPlantPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SelectPlantBloc, SelectPlantBlocState>(
      listener: (BuildContext context, SelectPlantBlocState state) {},
      child: BlocBuilder<SelectPlantBloc, SelectPlantBlocState>(
        bloc: BlocProvider.of<SelectPlantBloc>(context),
        builder: (BuildContext context, SelectPlantBlocState state) {
          Widget body = FullscreenLoading(
            title: 'Loading..',
          );
          int i = 0;

          if (state is SelectPlantBlocStateInit) {
            body = FullscreenLoading(
              title: 'Loading..',
            );
          } else if (state is SelectPlantBlocStateLoaded) {
            if (state.plants.length == 0) {
              if (state.noPublic) {
                body = _renderNoPublicPlant(context);
              } else {
                body = _renderNoPlant(context);
              }
            } else {
              body = Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0),
                    child: Text(state.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.boxes.length,
                      itemBuilder: (BuildContext context, int index) {
                        Box box = state.boxes[index];
                        List<Widget> content = [
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 1, offset: Offset(0, 2))],
                              color: Colors.white,
                            ),
                            child: ListTile(
                              leading: SvgPicture.asset('assets/settings/icon_lab.svg'),
                              title: Text(box.name),
                            ),
                          ),
                        ];
                        content.addAll(state.plants.where((p) => p.box == box.id).map((p) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: ListTile(
                              leading: SizedBox(
                                  width: 40, height: 40, child: SvgPicture.asset('assets/settings/icon_plants.svg')),
                              onTap: () {
                                BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop(param: p));
                              },
                              title: Text('${++i}. ${p.name}', style: TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text('Tap to select'),
                              trailing: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: SvgPicture.asset('assets/settings/icon_${p.synced ? '' : 'un'}synced.svg')),
                            ),
                          );
                        }).toList());
                        return Column(
                          children: content,
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          }
          return Scaffold(
              appBar: SGLAppBar(
                '🍁',
                fontSize: 40,
                backgroundColor: Color(0xff0bb354),
                titleColor: Colors.white,
                iconColor: Colors.white,
                hideBackButton: !(state is SelectPlantBlocStateLoaded),
                elevation: 10,
              ),
              body: AnimatedSwitcher(duration: Duration(milliseconds: 200), child: body));
        },
      ),
    );
  }

  Widget _renderNoPlant(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
            child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Text('You have no plant yet.', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w200)),
                  ),
                  Text('Add your first', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300)),
                  Text('PLANT', style: TextStyle(fontSize: 50, fontWeight: FontWeight.w200, color: Color(0xff3bb30b))),
                ],
              ),
            ),
            GreenButton(
              title: 'START',
              onPressed: () {
                BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToCreatePlantEvent());
              },
            ),
          ],
        )),
      ],
    );
  }

  Widget _renderNoPublicPlant(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
            child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Text('You have no private diaries to make public.\nCheck your plant settings to un-public a plant.', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w200)),
                  ),
                ],
              ),
            ),
            GreenButton(
              title: 'OPEN SETTINGS',
              onPressed: () {
                BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToSettingsPlants());
              },
            ),
          ],
        )),
      ],
    );
  }
}
