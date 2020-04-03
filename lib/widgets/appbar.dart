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

class SGLAppBar extends AppBar {
  SGLAppBar(String title, {List<Widget> actions, bool hideBackButton=false, titleColor=Colors.black, iconColor=Colors.black, backgroundColor=Colors.white, double elevation=0, double fontSize=23})
      : super(
          automaticallyImplyLeading: !hideBackButton,
          title: Text(title, style: TextStyle(color: titleColor, fontSize: fontSize)),
          iconTheme: IconThemeData(
            color: iconColor,
          ),
          actions: actions,
          centerTitle: true,
          backgroundColor: backgroundColor,
          elevation: elevation,
        );
}
