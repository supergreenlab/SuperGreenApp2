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

  double listHeight();
  double listItemWidth();

  @override
  _SectionPageState createState() => _SectionPageState<BlocType>();

  Widget renderBody(BuildContext context, SectionBlocStateLoaded state, List<dynamic> items) {
    return renderList(context, state, items);
  }

  Widget renderList(BuildContext context, SectionBlocStateLoaded state, List<dynamic> items) {
    return Container(
        height: listHeight(),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length + (state.eof ? 0 : 1),
            itemBuilder: (BuildContext context, int index) {
              Widget body;
              if (index == items.length) {
                BlocProvider.of<BlocType>(context).add(SectionBlocEventLoad(items.length));
                body = Container(
                  width: listItemWidth(),
                  child: renderLoading(),
                );
              } else {
                body = Container(
                  width: listItemWidth(),
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
        height: listHeight(),
        child: GridView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: items.length + (state.eof ? 0 : 1),
          itemBuilder: (BuildContext context, int index) {
            Widget body;
            if (index == items.length) {
              BlocProvider.of<BlocType>(context).add(SectionBlocEventLoad(items.length));
              body = Container(
                width: listItemWidth(),
                child: renderLoading(),
              );
            } else {
              body = Container(
                width: listItemWidth(),
                child: itemBuilder(context, items[index]),
              );
            }
            return body;
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 3, crossAxisSpacing: 3, childAspectRatio: 0.25),
        ));
  }

  Widget renderLoading() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(
        height: 40,
        width: 40,
        child: CircularProgressIndicator(
          strokeWidth: 3.0,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
        ),
      )
    ]);
  }
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
            body = Container(height: widget.listHeight(), child: FullscreenLoading());
          } else {
            body = widget.renderBody(context, state, items);
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
