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
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:super_green_app/data/rel/checklist/actions.dart';
import 'package:super_green_app/data/rel/checklist/categories.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/checklist/action_popup/checklist_action_popup_bloc.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/local/app_bar/checklist/actions/checklist_action_page.dart';
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

        return Container(
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
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: _renderBody(context, state as ChecklistActionPopupBlocStateLoaded),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _renderBody(BuildContext context, ChecklistActionPopupBlocStateLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _renderTitle(context, state),
        _renderChecklistSeed(context, state),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Actions",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff454545)),
          ),
        ),
        _renderActions(context, state),
      ],
    );
  }

  Widget _renderTitle(BuildContext context, ChecklistActionPopupBlocStateLoaded state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: SvgPicture.asset(
                  ChecklistCategoryIcons[state.checklistSeed.category]!,
                  width: 20,
                ),
              ),
              Text(
                state.checklistSeed.title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff454545)),
              ),
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
      ),
    );
  }

  Widget _renderChecklistSeed(BuildContext context, ChecklistActionPopupBlocStateLoaded state) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MarkdownBody(
            data: state.checklistSeed.description,
            styleSheet: MarkdownStyleSheet(p: TextStyle(color: Colors.black, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _renderActions(BuildContext context, ChecklistActionPopupBlocStateLoaded state) {
    return Expanded(
      child: Swiper(
        itemCount: state.checklistLogs.length,
        pagination: SwiperPagination(
          builder: new DotSwiperPaginationBuilder(color: Color(0xffdedede), activeColor: Color(0xff3bb30b)),
        ),
        loop: false,
        itemBuilder: (BuildContext context, int index) {
          ChecklistLog log = state.checklistLogs[index];
          return ChecklistActionButton.getActionPage(
            plant: state.plant,
            box: state.box,
            checklistSeed: state.checklistSeed,
            checklistAction: ChecklistAction.fromJSON(log.action),
            summarize: false,
          );
        },
      ),
    );
  }
}
