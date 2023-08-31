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
import 'package:flutter_svg/svg.dart';
import 'package:super_green_app/data/rel/checklist/categories.dart';
import 'package:super_green_app/pages/checklist/action_popup/checklist_action_popup_bloc.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class ChecklistActionPopupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChecklistActionPopupBloc, ChecklistActionPopupBlocState>(
      builder: (BuildContext context, ChecklistActionPopupBlocState state) {
        if (state is ChecklistActionPopupBlocStateInit) {
          return InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: FullscreenLoading(),
          );
        }

        return InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Color(0x10000000),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 24),
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: _renderBody(context, state as ChecklistActionPopupBlocStateLoaded),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _renderBody(BuildContext context, ChecklistActionPopupBlocStateLoaded state) {
    return Column(
      children: [
        _renderTitle(context, state),
      ],
    );
  }

  Widget _renderTitle(BuildContext context, ChecklistActionPopupBlocStateLoaded state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SvgPicture.asset(ChecklistCategoryNames[state.checklistSeed.category]!),
            Text(state.checklistSeed.title),
          ],
        ),
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 8.0),
            child: Icon(Icons.close),
          ),
        ),
      ],
    );
  }
}
