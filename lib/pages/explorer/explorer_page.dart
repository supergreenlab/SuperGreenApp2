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
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/explorer/explorer_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';

class ExplorerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExplorerBloc, ExplorerBlocState>(
        bloc: BlocProvider.of<ExplorerBloc>(context),
        builder: (context, state) => Scaffold(
            appBar: SGLAppBar(
              'Explorer',
              backgroundColor: Colors.deepPurple,
              titleColor: Colors.yellow,
              iconColor: Colors.white,
              elevation: 10,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SizedBox(
                            height: 100,
                            width: 100,
                            child: SvgPicture.asset(
                                'assets/feed_card/logo_sgl.svg')),
                      ),
                      Text(
                        'COMING SOON',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.grey),
                      ),
                      FlatButton(
                        onPressed: () {
                          BlocProvider.of<MainNavigatorBloc>(context)
                              .add(MainNavigateToPublicPlant('1655f201-c722-49ac-acd9-e1e3ff4c70c4'));
                        },
                        child: Text('public plant'),
                      ),
                    ],
                  ),
                )
              ],
            )));
  }
}
