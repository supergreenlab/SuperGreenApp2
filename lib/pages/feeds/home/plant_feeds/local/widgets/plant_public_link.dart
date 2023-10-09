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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_extend/share_extend.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/local/plant_feed_bloc.dart';
import 'package:super_green_app/widgets/green_button.dart';

class PlantPublicLink extends StatefulWidget {
  final PlantFeedBlocStateLoaded state;
  final Function() onMakePublic;

  const PlantPublicLink({Key? key, required this.state, required this.onMakePublic}) : super(key: key);

  @override
  State<PlantPublicLink> createState() => _PlantPublicLinkState();
}

class _PlantPublicLinkState extends State<PlantPublicLink> {
  bool isPublic = false;

  void initState() {
    isPublic = widget.state.plant.public;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!isPublic) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 30, top: 16.0, left: 16.0, right: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Link sharing requires to make the plant public first.',
                maxLines: 3,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            GreenButton(
              title: 'Tap to make public',
              onPressed: () {
                widget.onMakePublic();
                setState(() {
                  isPublic = true;
                });
              },
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 30, top: 16.0, left: 16.0, right: 16.0),
      child: InkWell(
        onTap: () async {
          await ShareExtend.share("https://supergreenlab.com/public/plant?id=${widget.state.plant.serverID}", 'text');
          Navigator.of(context).pop();
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Tap to copy link:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff454545),
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset('assets/home/icon_share_link.svg', color: Color(0xff454545), width: 20, height: 20,),
                ),
                Expanded(
                  child: Text(
                    'https://supergreenlab.com/public/plant?id=${widget.state.plant.serverID}',
                    maxLines: 2,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff2ba300),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
