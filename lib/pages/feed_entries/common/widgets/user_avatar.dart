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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:super_green_app/data/analytics/matomo.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class UserAvatar extends TraceableStatelessWidget {
  final String? icon;
  final double size;

  const UserAvatar({Key? key, this.icon, this.size = 40}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String icon = this.icon ?? 'assets/feed_card/icon_noavatar.png';
    Image image;
    if (icon.startsWith("http")) {
      image = Image.network(
        icon,
        headers: {'Host': BackendAPI().storageServerHostHeader},
        width: size,
        height: size,
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return FullscreenLoading(
              percent: loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!);
        },
      );
    } else if (icon.startsWith('assets/')) {
      image = Image.asset(icon, fit: BoxFit.cover, width: size, height: size);
    } else {
      image = Image.file(File(icon), fit: BoxFit.cover, width: size, height: size);
    }
    return Container(
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xffbdbdbd)), borderRadius: BorderRadius.all(Radius.circular(size / 2))),
      child: InkWell(
        child: ClipRRect(borderRadius: BorderRadius.circular(size / 2), child: image),
      ),
    );
  }
}
