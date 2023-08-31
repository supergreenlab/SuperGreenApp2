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

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_green_app/data/assets/checklist.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/data/rel/checklist/actions.dart';
import 'package:super_green_app/pages/checklist/action_popup/checklist_action_popup_bloc.dart';
import 'package:super_green_app/pages/checklist/action_popup/checklist_action_popup_page.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/common/widgets/app_bar_action.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/local/app_bar/checklist/actions/checklist_action_page.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/local/app_bar/checklist/actions/widgets/checklist_log_button_bar.dart';
import 'package:super_green_app/widgets/favicon.dart';
import 'package:url_launcher/url_launcher.dart';

class ChecklistActionWebpageButton extends ChecklistActionButton {
  ChecklistActionWebpageButton(
      {required Plant plant,
      required Box box,
      required ChecklistSeed checklistSeed,
      required ChecklistAction checklistAction,
      required Function()? onCheck,
      required Function()? onSkip,
      required bool summarize})
      : super(
            plant: plant,
            box: box,
            checklistSeed: checklistSeed,
            checklistAction: checklistAction,
            onCheck: onCheck,
            onSkip: onSkip,
            summarize: summarize);

  @override
  Widget build(BuildContext context) {
    Uri url = Uri.parse((checklistAction as ChecklistActionWebpage).url!);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: AppBarAction(
        shadowed: summarize,
        iconWidget: FaviconImage(
          url: (checklistAction as ChecklistActionWebpage).url!,
          alternativeImage: SvgPicture.asset(ChecklistActionIcons[ChecklistActionWebpage.TYPE]!),
        ),
        color: Colors.teal,
        title: checklistSeed.title,
        onCheck: onCheck,
        onSkip: onSkip,
        child: summarize ? null : _renderBody(context),
        content: AutoSizeText(
          url.host,
          maxLines: 1,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w300,
            color: Color(0xff454545),
          ),
        ),
        action: () async {
          if (this.summarize && !this.checklistSeed.fast) {
            await showModalBottomSheet<bool>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (BuildContext c) {
                return BlocProvider<ChecklistActionPopupBloc>(
                  create: (BuildContext context) =>
                      ChecklistActionPopupBloc(this.plant, this.box, this.checklistSeed, this.checklistAction),
                  child: ChecklistActionPopupPage(),
                );
              },
            );
          } else {
            launchUrl(url);
          }
        },
        actionIcon: !summarize ? null : SvgPicture.asset(ChecklistActionIcons[ChecklistActionWebpage.TYPE]!),
      ),
    );
  }

  Widget _renderBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: MarkdownBody(
              data: (checklistAction as ChecklistActionMessage).instructions ?? '',
              styleSheet: MarkdownStyleSheet(p: TextStyle(color: Colors.black, fontSize: 16)),
            ),
          ),
          ChecklistLogButtonBottomBar(),
        ],
      ),
    );
  }
}
