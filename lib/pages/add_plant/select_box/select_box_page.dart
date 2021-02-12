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
import 'package:intl/intl.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/l10n/common.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_plant/select_box/select_box_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';

class SelectBoxPage extends StatelessWidget {
  static String get selectBoxPageNoLab {
    return Intl.message(
      'You have no lab yet',
      name: 'selectBoxPageNoLab',
      desc: 'Message displayed when the app has no lab created yet.',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get selectBoxPageCreateFirst {
    return Intl.message(
      'Create your first',
      name: 'selectBoxPageCreateFirst',
      desc: 'First part of the "Create your first GREEN LAB" text',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get selectBoxPageCreateFirstLab {
    return Intl.message(
      'GREEN LAB',
      name: 'selectBoxPageCreateFirstLab',
      desc: 'Displayed under the selectBoxPageCreateFirstLab text',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get selectBoxPageCreateLabButton {
    return Intl.message(
      'CREATE',
      name: 'selectBoxPageCreateLabButton',
      desc: 'Lab creation button label',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get selectBoxPageAddNewGreenLab {
    return Intl.message(
      'Add new green lab',
      name: 'selectBoxPageAddNewGreenLab',
      desc: 'Last item of the Lab list is a button to create a new one',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get selectBoxPageTapSelect {
    return Intl.message(
      'Tap to select',
      name: 'selectBoxPageTapSelect',
      desc: 'Label for the Labs list items',
      locale: SGLLocalizations.current.localeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectBoxBloc, SelectBoxBlocState>(
        cubit: BlocProvider.of<SelectBoxBloc>(context),
        builder: (BuildContext context, SelectBoxBlocState state) {
          Widget body;
          if (state is SelectBoxBlocStateLoading) {
            body = FullscreenLoading(
              title: CommonL10N.done,
            );
          } else if (state is SelectBoxBlocStateLoaded) {
            if (state.boxes.length == 0) {
              body = _renderNoBox(context);
            } else {
              body = Column(
                children: <Widget>[
                  SectionTitle(
                    title: 'Select lab below',
                    icon: 'assets/settings/icon_lab.svg',
                    titleColor: Colors.green,
                    backgroundColor: Colors.yellow,
                    elevation: 4,
                  ),
                  Expanded(child: _renderBoxList(context, state)),
                ],
              );
            }
          }
          return Scaffold(
              appBar: SGLAppBar(
                '⚗️',
                fontSize: 35,
                backgroundColor: Colors.yellow,
                titleColor: Colors.green,
                iconColor: Colors.green,
                elevation: state is SelectBoxBlocStateLoaded && state.boxes.length == 0 ? 4 : 0,
              ),
              body: AnimatedSwitcher(
                duration: Duration(milliseconds: 200),
                child: body,
              ));
        });
  }

  Widget _renderNoBox(BuildContext context) {
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
                    child: Text(SelectBoxPage.selectBoxPageNoLab,
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w200)),
                  ),
                  Text(SelectBoxPage.selectBoxPageCreateFirst,
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300)),
                  Text(
                    SelectBoxPage.selectBoxPageCreateFirstLab,
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.w200, color: Color(0xff3bb30b)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            GreenButton(
              title: SelectBoxPage.selectBoxPageCreateLabButton,
              onPressed: () {
                _createNewBox(context);
              },
            ),
          ],
        )),
      ],
    );
  }

  Widget _renderBoxList(BuildContext context, SelectBoxBlocStateLoaded state) {
    return ListView.builder(
      itemCount: state.boxes.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index >= state.boxes.length) {
          return ListTile(
            leading: Icon(Icons.add),
            title: Text(SelectBoxPage.selectBoxPageAddNewGreenLab),
            onTap: () {
              _createNewBox(context);
            },
          );
        }
        return ListTile(
          leading: SvgPicture.asset('assets/settings/icon_lab.svg'),
          title: Text(state.boxes[index].name, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(SelectBoxPage.selectBoxPageTapSelect),
          onTap: () {
            BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop(param: state.boxes[index]));
          },
        );
      },
    );
  }

  void _createNewBox(BuildContext context) {
    BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToCreateBoxEvent(futureFn: (future) async {
      dynamic res = await future;
      if (res is Box) {
        BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop(param: res));
      }
    }));
  }
}
