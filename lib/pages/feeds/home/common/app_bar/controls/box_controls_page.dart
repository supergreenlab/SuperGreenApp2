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
import 'package:super_green_app/pages/feeds/home/common/app_bar/controls/box_controls_bloc.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/widgets/app_bar_tab.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class BoxControlsPage extends StatelessWidget {
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
    return BlocListener<BoxControlsBloc, BoxControlsBlocState>(
      listener: (BuildContext context, BoxControlsBlocState state) {
        if (state is BoxControlsBlocStateLoaded) {}
      },
      child: BlocBuilder<BoxControlsBloc, BoxControlsBlocState>(
          bloc: BlocProvider.of<BoxControlsBloc>(context),
          builder: (BuildContext context, BoxControlsBlocState state) {
            if (state is BoxControlsBlocStateInit) {
              return AppBarTab(child: _renderLoading(context, state));
            }
            return AppBarTab(child: _renderLoaded(context, state as BoxControlsBlocStateLoaded));
          }),
    );
  }

  Widget _renderLoading(BuildContext context, BoxControlsBlocStateInit state) {
    return FullscreenLoading(
      title: BoxControlsPage.plantStatusPageLoadingPlantData,
    );
  }

  Widget _renderLoaded(BuildContext context, BoxControlsBlocStateLoaded state) {
    return Text('loaded');
  }
}
