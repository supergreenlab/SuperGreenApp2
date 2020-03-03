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
import 'package:super_green_app/data/towelie/towelie_bloc.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/main/main_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

void main() async {
  runApp(MultiBlocProvider(providers: <BlocProvider>[
    BlocProvider<MainNavigatorBloc>(
        create: (context) => MainNavigatorBloc(navigatorKey)),
    BlocProvider<TowelieBloc>(create: (context) => TowelieBloc()),
  ], child: MainPage(navigatorKey)));
}
