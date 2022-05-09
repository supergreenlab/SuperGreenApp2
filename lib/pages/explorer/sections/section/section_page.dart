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
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/explorer/sections/section/section_bloc.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/item_loading.dart';

abstract class SectionPage<BlocType extends SectionBloc, ItemType> extends StatefulWidget {
  Widget itemBuilder(BuildContext context, ItemType item);
  Widget sectionTitle(BuildContext context);

  double get listHeight;
  double get listItemWidth;

  @override
  _SectionPageState createState() => _SectionPageState<BlocType>();

  Widget renderBody(BuildContext context, SectionBlocStateLoaded state, List<dynamic> items) {
    return renderList(context, state, items);
  }

  Widget renderList(BuildContext context, SectionBlocStateLoaded state, List<dynamic> items) {
    return Container(
        height: listHeight,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length + (state.eof ? 0 : 1),
            itemBuilder: (BuildContext context, int index) {
              Widget body;
              if (index == items.length) {
                BlocProvider.of<BlocType>(context).add(SectionBlocEventLoad(items.length));
                body = Container(
                  width: listItemWidth,
                  child: ItemLoading(),
                );
              } else {
                body = Container(
                  width: listItemWidth,
                  child: itemBuilder(context, items[index]),
                );
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: body,
              );
            }));
  }

  Widget renderGrid(BuildContext context, SectionBlocStateLoaded state, List<dynamic> items) {
    return Container(
        height: listHeight,
        child: GridView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: items.length + (state.eof ? 0 : 1),
          itemBuilder: (BuildContext context, int index) {
            Widget body;
            if (index == items.length) {
              BlocProvider.of<BlocType>(context).add(SectionBlocEventLoad(items.length));
              body = Container(
                width: listItemWidth,
                child: ItemLoading(),
              );
            } else {
              body = Container(
                width: listItemWidth,
                child: itemBuilder(context, items[index]),
              );
            }
            return body;
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 3, crossAxisSpacing: 3, childAspectRatio: 0.25),
        ));
  }

  Widget renderEmpty(BuildContext context) {
    return Container(
      height: listHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Nothing to see here (yet)',
              style: TextStyle(
                fontSize: 17,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget renderNotLogged(BuildContext context) {
    return Container(
      height: listHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Create an account',
              style: TextStyle(
                fontSize: 17,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          GreenButton(
            onPressed: () {
              BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToSettingsAuth());
            },
            title: 'Login or create account',
          )
        ],
      ),
    );
  }
}

class _SectionPageState<BlocType extends SectionBloc> extends State<SectionPage> {
  List<dynamic> items = [];
  bool empty = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<BlocType, SectionBlocState>(
      listener: (BuildContext context, SectionBlocState state) {
        if (state is SectionBlocStateLoaded) {
          setState(() {
            items.addAll(state.items);
            if (items.length == 0) {
              empty = true;
            }
          });
        } else if (state is SectionBlocStateClear) {
          setState(() {
            items.clear();
          });
        }
      },
      child: BlocBuilder<BlocType, SectionBlocState>(
        buildWhen: (SectionBlocState s1, SectionBlocState s2) => !(s2 is SectionBlocStateClear),
        builder: (BuildContext context, SectionBlocState state) {
          Widget body;
          if (state is SectionBlocStateNotLogged) {
            body = widget.renderNotLogged(context);
          } else {
            if (empty) {
              body = widget.renderEmpty(context);
            } else if (items.length == 0) {
              body = Container(height: widget.listHeight, child: ItemLoading());
            } else {
              body = widget.renderBody(context, state as SectionBlocStateLoaded, items);
            }
          }
          return Column(
            children: [
              widget.sectionTitle(context),
              body,
            ],
          );
        },
      ),
    );
  }
}
