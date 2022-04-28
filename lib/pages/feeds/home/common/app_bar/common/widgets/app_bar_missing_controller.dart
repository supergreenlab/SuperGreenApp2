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
import 'package:intl/intl.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:url_launcher/url_launcher.dart';

class AppBarMissingController extends StatelessWidget {
  static String get appBarMissingControllerControllerRequired {
    return Intl.message(
      'Monitoring feature\nrequires an SGL controller',
      name: 'appBarMissingControllerControllerRequired',
      desc: 'Message over the graphs when controller is missing',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get appBarMissingControllerShopNow {
    return Intl.message(
      'SHOP NOW',
      name: 'appBarMissingControllerShopNow',
      desc: 'SHOW NOW button displayed when controller is missing',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get appBarMissingControllerOr {
    return Intl.message(
      'or',
      name: 'appBarMissingControllerOr',
      desc: 'SHOW NOW *or* DIY NOW displayed when controller is missing',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get appBarMissingControllerDIYNow {
    return Intl.message(
      'DIY NOW',
      name: 'appBarMissingControllerDIYNow',
      desc: 'DIY NOW button displayed when controller is missing',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get appBarMissingControllerAlreadyGotOne {
    return Intl.message(
      'already got one?',
      name: 'appBarMissingControllerAlreadyGotOne',
      desc:
          'label for the SETUP CONTROLLER button displayed when controller is missing, opens the select controller dialog',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get appBarMissingControllerSetupController {
    return Intl.message(
      'SETUP CONTROLLER',
      name: 'appBarMissingControllerSetupController',
      desc: 'SETUP CONTROLLER displayed when controller is missing, opens the select controller dialog',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  final Box box;

  const AppBarMissingController(this.box, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.white.withAlpha(220)),
      child: Fullscreen(
        fontSize: 15,
        fontWeight: FontWeight.normal,
        title: AppBarMissingController.appBarMissingControllerControllerRequired,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GreenButton(
                  title: AppBarMissingController.appBarMissingControllerShopNow,
                  onPressed: () {
                    launch('https://www.supergreenlab.com');
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(AppBarMissingController.appBarMissingControllerOr,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                GreenButton(
                  title: AppBarMissingController.appBarMissingControllerSetupController,
                  onPressed: () {
                    BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToSettingsBox(box));
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('or '),
                  InkWell(
                    child: Text(
                      AppBarMissingController.appBarMissingControllerDIYNow,
                      style: TextStyle(
                        fontSize: 20,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onTap: () {
                      launch('https://github.com/supergreenlab');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        childFirst: false,
      ),
    );
  }
}
