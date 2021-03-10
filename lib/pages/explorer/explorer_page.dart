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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:super_green_app/data/analytics/matomo.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/l10n/common.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/notifications/notifications.dart';
import 'package:super_green_app/pages/explorer/explorer_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class ExplorerPage extends TraceableStatefulWidget {
  static String get explorerPageTitle {
    return Intl.message(
      'Explorer',
      name: 'explorerPageTitle',
      desc: 'Explorer page title',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get explorerPageSelectPlantTitle {
    return Intl.message(
      'Select which plant you want to make public',
      name: 'explorerPageSelectPlantTitle',
      desc: 'Title of the select page when selecting a plant to make public',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String explorerPagePublicPlantConfirmation(String name) {
    return Intl.message(
      'Plant $name is now public',
      args: [name],
      name: 'explorerPagePublicPlantConfirmation',
      desc: 'Confirmation text when a plant is now public',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get explorerPagePleaseLoginDialogTitle {
    return Intl.message(
      'Make a plant public',
      name: 'explorerPagePleaseLoginDialogTitle',
      desc: 'Title for the dialog when the user is not connected',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get explorerPagePleaseLoginDialogBody {
    return Intl.message(
      'You need to be logged in to make a plant public.',
      name: 'explorerPagePleaseLoginDialogBody',
      desc: 'Content for the dialog when the user is not connected',
      locale: SGLLocalizations.current.localeName,
    );
  }

  @override
  _ExplorerPageState createState() => _ExplorerPageState();
}

class _ExplorerPageState extends State<ExplorerPage> {
  List<PlantState> plants = [];

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExplorerBloc, ExplorerBlocState>(
      listener: (BuildContext context, ExplorerBlocState state) {
        if (state is ExplorerBlocStateLoaded) {
          setState(() {
            plants.addAll(state.plants);
          });
        }
      },
      child: BlocBuilder<ExplorerBloc, ExplorerBlocState>(
          cubit: BlocProvider.of<ExplorerBloc>(context),
          builder: (context, state) {
            Widget body;
            if (state is ExplorerBlocStateInit) {
              body = FullscreenLoading();
            } else if (state is ExplorerBlocStateLoaded) {
              body = _renderList(context, state);
            }
            return Scaffold(
                appBar: SGLAppBar(
                  ExplorerPage.explorerPageTitle,
                  backgroundColor: Colors.deepPurple,
                  titleColor: Colors.yellow,
                  iconColor: Colors.white,
                  elevation: 10,
                  hideBackButton: true,
                  actions: [
                    IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      onPressed: () => onMakePublic(state),
                    ),
                  ],
                  leading: IconButton(
                    icon: Icon(
                      Icons.bookmark,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToBookmarks());
                    },
                  ),
                ),
                body: body);
          }),
    );
  }

  Widget _renderList(BuildContext context, ExplorerBlocStateLoaded state) {
    if (plants.length == 0) {
      return FullscreenLoading();
    }
    return GridView.builder(
      itemCount: state.eof ? plants.length : plants.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index > plants.length) {
          return null;
        }
        if (index == plants.length) {
          if (state.eof) {
            return null;
          }
          BlocProvider.of<ExplorerBloc>(context).add(ExplorerBlocEventLoadNextPage(plants.length));
          return FullscreenLoading();
        }
        return _renderPlant(context, plants[index]);
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
    );
  }

  Widget _renderPlant(BuildContext context, PlantState plant) {
    Widget pic;
    if (plant.thumbnailPath == '') {
      pic = SvgPicture.asset('assets/explorer/no_pic.svg', fit: BoxFit.cover);
    } else {
      pic = Image.network(BackendAPI().feedsAPI.absoluteFileURL(plant.thumbnailPath), fit: BoxFit.cover);
    }
    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        return InkWell(
          onTap: () {
            BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToPublicPlant(plant.id, name: plant.name));
          },
          child: Stack(
            children: <Widget>[
              Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: pic,
              ),
              Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '${plant.name}',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              )),
            ],
          ),
        );
      },
    );
  }

  void onMakePublic(ExplorerBlocState state) {
    if (state is ExplorerBlocStateLoaded && state.loggedIn) {
      BlocProvider.of<MainNavigatorBloc>(context).add(
          MainNavigateToSelectPlantEvent(ExplorerPage.explorerPageSelectPlantTitle, futureFn: (Future future) async {
        dynamic plant = await future;
        if (plant == null) {
          return;
        }
        if (plant is Plant) {
          BlocProvider.of<ExplorerBloc>(context).add(ExplorerBlocEventMakePublic(plant));
          plants.clear();
          BlocProvider.of<ExplorerBloc>(context).add(ExplorerBlocEventInit());
          Fluttertoast.showToast(msg: ExplorerPage.explorerPagePublicPlantConfirmation(plant.name));
          Timer(Duration(milliseconds: 1000), () {
            BlocProvider.of<NotificationsBloc>(context).add(NotificationsBlocEventRequestPermission());
          });
        }
      }));
    } else {
      _login(context);
    }
  }

  void _login(BuildContext context) async {
    bool confirm = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(ExplorerPage.explorerPagePleaseLoginDialogTitle),
            content: Text(ExplorerPage.explorerPagePleaseLoginDialogBody),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text(CommonL10N.cancel),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text(CommonL10N.loginCreateAccount),
              ),
            ],
          );
        });
    if (confirm) {
      BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToSettingsAuth());
    }
  }
}
