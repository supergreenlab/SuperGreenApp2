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
import 'package:super_green_app/pages/explorer/sections/section/section_bloc.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

abstract class SectionPage<BlocType extends SectionBloc, ItemType> extends StatefulWidget {
  Widget itemBuilder(BuildContext context, ItemType item);
  Widget sectionTitle(BuildContext context);

  @override
  _SectionPageState createState() => _SectionPageState<BlocType>();
}

class _SectionPageState<BlocType extends SectionBloc> extends State<SectionPage> {
  List<dynamic> items = [];

  @override
  Widget build(BuildContext context) {
    return BlocListener<BlocType, SectionBlocState>(
      listener: (BuildContext context, SectionBlocState state) {
        if (state is SectionBlocStateLoaded) {
          setState(() {
            items.addAll(state.items);
          });
        }
      },
      child: BlocBuilder<BlocType, SectionBlocState>(
        builder: (BuildContext context, SectionBlocState state) {
          Widget body;
          if (items.length == 0) {
            body = FullscreenLoading();
          } else {
            body = renderList(context, state);
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

  Widget renderList(BuildContext context, SectionBlocStateLoaded state) {
    return Container(
        height: 250,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length + (state.eof ? 0 : 1),
            itemBuilder: (BuildContext context, int index) {
              Widget body;
              if (index == items.length) {
                BlocProvider.of<BlocType>(context).add(SectionBlocEventLoad(items.length));
                body = Container(
                  width: 250,
                  child: FullscreenLoading(),
                );
              } else {
                body = Container(
                  width: 250,
                  child: widget.itemBuilder(context, items[index]),
                );
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: body,
              );
            }));
  }
}
