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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:super_green_app/data/analytics/matomo.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/l10n/common.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/plant_picker/plant_picker_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';

class PlantPickerPage extends TraceableStatefulWidget {
  static String plantPickerPageSelectButton(int count) {
    return Intl.message(
      'SELECT ($count)',
      args: [count],
      name: 'plantPickerPageSelectButton',
      desc: 'Confirmation button for the plant picker page',
      locale: SGLLocalizations.current.localeName,
    );
  }

  @override
  _PlantPickerPageState createState() => _PlantPickerPageState();
}

class _PlantPickerPageState extends State<PlantPickerPage> {
  List<Plant> selectedPlants = [];

  @override
  Widget build(BuildContext context) {
    return BlocListener<PlantPickerBloc, PlantPickerBlocState>(
      listener: (BuildContext context, PlantPickerBlocState state) {
        if (state is PlantPickerBlocStateLoaded) {
          setState(() {
            selectedPlants = state.selectedPlants ?? [];
          });
        }
      },
      child: BlocBuilder<PlantPickerBloc, PlantPickerBlocState>(
        builder: (BuildContext context, PlantPickerBlocState state) {
          Widget body = Container();
          if (state is PlantPickerBlocStateInit) {
            body = FullscreenLoading(title: CommonL10N.loading);
          } else if (state is PlantPickerBlocStateLoaded) {
            body = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(state.title, style: TextStyle(fontSize: 20)),
                ),
                Expanded(child: renderPlantsList(context, state.boxes, state.plants)),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GreenButton(
                      title: PlantPickerPage.plantPickerPageSelectButton(selectedPlants.length),
                      onPressed: () {
                        BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop(param: selectedPlants));
                      },
                    ),
                  ),
                ),
              ],
            );
          }
          return Scaffold(
              appBar: SGLAppBar(
                '🛠',
                fontSize: 40,
                backgroundColor: Color(0xff3bb30b),
                titleColor: Colors.white,
                iconColor: Colors.white,
              ),
              backgroundColor: Colors.white,
              body: AnimatedSwitcher(duration: Duration(milliseconds: 200), child: body));
        },
      ),
    );
  }

  Widget renderPlantsList(BuildContext context, List<Box> boxes, List<Plant> plants) {
    List<Widget> children = [];
    for (Box box in boxes) {
      List<Plant> ps = plants.where((p) => p.box == box.id).toList();
      if (ps.length > 0) {
        children.add(ListTile(
          leading: SvgPicture.asset('assets/settings/icon_lab.svg'),
          title: Text(box.name),
        ));
        children.addAll(ps.map((plant) => Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: ListTile(
                leading: selectedPlants.contains(plant)
                    ? Icon(
                        Icons.check_box,
                        color: Colors.green,
                      )
                    : Icon(Icons.crop_square),
                title: Text(plant.name),
                onTap: () {
                  setState(() {
                    if (selectedPlants.contains(plant)) {
                      selectedPlants.remove(plant);
                    } else {
                      selectedPlants.add(plant);
                    }
                  });
                },
              ),
            )));
      }
    }
    return ListView(
      children: children,
    );
  }
}
