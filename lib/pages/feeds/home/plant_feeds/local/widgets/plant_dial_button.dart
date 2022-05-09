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
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class PlantDialButton extends StatefulWidget {
  final bool openned;

  const PlantDialButton({Key? key, required this.openned}) : super(key: key);

  @override
  _PlantDialButtonState createState() => _PlantDialButtonState();
}

class _PlantDialButtonState extends State<PlantDialButton> {
  Artboard? _riveArtboard;
  late RiveAnimationController _controller;

  bool openned = false;

  @override
  void initState() {
    super.initState();

    rootBundle.load('assets/home/dial_button.riv').then((data) {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      _controller = SimpleAnimation('idle');
      artboard.addController(_controller);
      setState(() => _riveArtboard = artboard);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_riveArtboard != null && openned != widget.openned) {
      if (widget.openned == true) {
        _riveArtboard!.removeController(_controller);
        _riveArtboard!.addController(_controller = SimpleAnimation('open'));
      } else {
        _riveArtboard!.removeController(_controller);
        _riveArtboard!.addController(_controller = SimpleAnimation('close'));
      }
      openned = widget.openned;
    }
    return _riveArtboard == null
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.all(4.0),
            child: Rive(artboard: _riveArtboard!),
          );
  }
}
