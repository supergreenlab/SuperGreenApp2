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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/api/backend/feeds/models/comments.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/explorer/models/feedentries.dart';
import 'package:super_green_app/pages/explorer/sections/discussions/discussions_bloc.dart';
import 'package:super_green_app/pages/explorer/sections/section/section_page.dart';
import 'package:super_green_app/pages/explorer/sections/widgets/list_title.dart';
import 'package:super_green_app/pages/explorer/sections/widgets/plant_phase.dart';
import 'package:super_green_app/pages/explorer/sections/widgets/plant_strain.dart';
import 'package:super_green_app/pages/feed_entries/common/comments/form/comments_form_page.dart';
import 'package:super_green_app/data/assets/feed_entry.dart';
import 'package:super_green_app/pages/feed_entries/common/widgets/user_avatar.dart';
import 'package:super_green_app/widgets/item_loading.dart';

class DiscussionsPage extends SectionPage<DiscussionsBloc, PublicFeedEntry> {
  @override
  double get listItemWidth {
    return 435;
  }

  @override
  double get listHeight {
    return 160;
  }

  Widget itemBuilder(BuildContext context, PublicFeedEntry feedEntry) {
    String? pic = feedEntry.pic;
    if (pic != null) {
      pic = BackendAPI().feedsAPI.absoluteFileURL(pic);
    }
    Widget avatar = UserAvatar(
      icon: pic,
      size: 40,
    );
    if (feedEntry.commentType != CommentType.COMMENT) {
      avatar = Stack(
        children: [
          avatar,
          Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Color(0xffcdcdcd), width: 1),
                    borderRadius: BorderRadius.circular(20)),
                child: Image.asset(commentTypes[feedEntry.commentType]!['pic']!, width: 25, height: 25),
              )),
        ],
      );
    }
    return InkWell(
      onTap: () {
        BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToPublicPlant(
          feedEntry.plantID!,
          name: feedEntry.plantName,
          feedEntryID: feedEntry.id,
          commentID: feedEntry.commentID,
          replyTo: feedEntry.replyTo,
        ));
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Color(0xffdedede)), borderRadius: BorderRadius.circular(5.0)),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Image.asset(commentTypes[feedEntry.commentType]!['pic']!, width: 20, height: 20),
                    ),
                    Text(feedEntry.plantName!,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          (feedEntry.thumbnailPath ?? "") != "" || (feedEntry.plantThumbnailPath ?? "") != "" ? Image.network(
                              BackendAPI()
                                  .feedsAPI
                                  .absoluteFileURL(feedEntry.thumbnailPath ?? feedEntry.plantThumbnailPath ?? ""),
                              fit: BoxFit.cover,
                              headers: {'Host': BackendAPI().storageServerHostHeader},
                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return ItemLoading();
                          }) : SvgPicture.asset(FeedEntryIcons[feedEntry.type] ?? ""),
                          Positioned(
                            child: avatar,
                            top: -4,
                            right: -4,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 4.0),
                              child: MarkdownBody(
                                data: '**${feedEntry.nickname}** ${feedEntry.commentTruncated}',
                                styleSheet: MarkdownStyleSheet(p: TextStyle(color: Color(0xff454545), fontSize: 14)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: PlantStrain(plantSettings: feedEntry.plantSettings)),
                  Expanded(child: PlantPhase(plantSettings: feedEntry.plantSettings)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(BuildContext context) {
    return ListTitle(
      title: 'Latest discussions',
    );
  }
}
