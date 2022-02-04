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

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/local/app_bar/status/plant_status_bloc.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class PlantStatusPage extends StatelessWidget {
  static String get plantStatusPageLoadingPlantData {
    return Intl.message(
      'Loading plant data',
      name: 'productsPageLoadingPlantData',
      desc: 'Products page loading plant data',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PlantStatusBloc, PlantStatusBlocState>(
      listener: (BuildContext context, PlantStatusBlocState state) {
        if (state is PlantStatusBlocStateLoaded) {}
      },
      child: BlocBuilder<PlantStatusBloc, PlantStatusBlocState>(
          bloc: BlocProvider.of<PlantStatusBloc>(context),
          builder: (BuildContext context, PlantStatusBlocState state) {
            if (state is PlantStatusBlocStateInit) {
              return _renderLoading(context, state);
            }
            return _renderLoaded(context, state as PlantStatusBlocStateLoaded);
          }),
    );
  }

  Widget _renderLoading(BuildContext context, PlantStatusBlocStateInit state) {
    return FullscreenLoading(
      title: PlantStatusPage.plantStatusPageLoadingPlantData,
    );
  }

  Widget _renderLoaded(BuildContext context, PlantStatusBlocStateLoaded state) {
    return Text('loaded');
  }
}
