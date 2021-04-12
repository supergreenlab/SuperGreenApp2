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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/explorer/models/feedentries.dart';
import 'package:super_green_app/pages/explorer/sections/likes/likes_bloc.dart';
import 'package:super_green_app/pages/explorer/sections/section/section_bloc.dart';
import 'package:super_green_app/pages/explorer/sections/section/section_page.dart';
import 'package:super_green_app/pages/explorer/sections/widgets/list_title.dart';
import 'package:super_green_app/pages/feed_entries/common/widgets/user_avatar.dart';
import 'package:super_green_app/widgets/item_loading.dart';

class LikesPage extends SectionPage<LikesBloc, PublicFeedEntry> {
  @override
  double listItemWidth() {
    return 100;
  }

  @override
  double listHeight() {
    return 150;
  }

  Widget renderBody(BuildContext context, SectionBlocStateLoaded state, List<dynamic> items) {
    return renderGrid(context, state, items);
  }

  Widget itemBuilder(BuildContext context, PublicFeedEntry feedEntry) {
    String pic = feedEntry.pic;
    if (pic != null) {
      pic = BackendAPI().feedsAPI.absoluteFileURL(pic);
    }
    Duration diff = DateTime.now().difference(feedEntry.likeDate);
    Widget avatar = UserAvatar(
      icon: pic,
      size: 20,
    );
    return InkWell(
      onTap: () {
        BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToPublicPlant(
          feedEntry.plantID,
          name: feedEntry.plantName,
          feedEntryID: feedEntry.id,
          commentID: feedEntry.commentID,
          replyTo: feedEntry.replyTo,
        ));
      },
      child: Container(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container(
                width: 60,
                height: 60,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                        BackendAPI().feedsAPI.absoluteFileURL(feedEntry.thumbnailPath ?? feedEntry.plantThumbnailPath),
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return ItemLoading();
                    }),
                    SvgPicture.asset(
                      'assets/explorer/heart_mask.svg',
                      fit: BoxFit.fill,
                    ),
                    Positioned(
                      child: avatar,
                      bottom: 0,
                      right: 0,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(feedEntry.nickname,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        Text(feedEntry.commentID != null
                            ? (feedEntry.replyTo != null ? ' liked a reply' : ' liked a comment')
                            : ' liked a diary entry'),
                      ],
                    ),
                    Text(feedEntry.plantName,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff464646),
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(BuildContext context) {
    return ListTitle(
      title: 'Latest likes',
    );
  }
}
