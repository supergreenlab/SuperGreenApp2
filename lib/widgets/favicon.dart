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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:favicon/favicon.dart' as fav;
import 'package:flutter/material.dart';
import 'package:super_green_app/data/kv/app_db.dart';

class FaviconImage extends StatefulWidget {
  final String url;
  final Widget alternativeImage;

  const FaviconImage({Key? key, required this.alternativeImage, required this.url}) : super(key: key);

  @override
  State<FaviconImage> createState() => _FaviconState();
}

class _FaviconState extends State<FaviconImage> {
  String? iconUrl;

  @override
  void initState() {
    loadFavicon();
    super.initState();
  }

  void loadFavicon() async {
    if (AppDB().getCachedString(widget.url) == null) {
      fav.Favicon? favico = await fav.FaviconFinder.getBest(widget.url);
      if (favico == null) {
        return;
      }
      AppDB().setCachedString(widget.url, favico.url);
      setState(() {
        this.iconUrl = favico.url;
      });
    } else {
      setState(() {
        this.iconUrl = AppDB().getCachedString(widget.url);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (iconUrl != null) {
      return CachedNetworkImage(
        imageUrl: iconUrl!,
        width: 35,
        height: 35,
        fit: BoxFit.contain,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) {
          AppDB().deleteCacheString(widget.url);
          return widget.alternativeImage;
        },
      );
    }
    return widget.alternativeImage;
  }
}
