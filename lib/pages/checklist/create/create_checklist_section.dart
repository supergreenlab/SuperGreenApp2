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

class CreateChecklistSection extends StatelessWidget {
  final Widget? icon;
  final String? title;
  final Widget? titleWidget;
  final Widget child;
  final void Function()? onClose;
  final bool noBorder;
  final bool hideTitle;

  const CreateChecklistSection(
      {Key? key, required this.child, this.title, this.titleWidget, this.onClose, this.icon, this.noBorder = false, this.hideTitle=false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BoxDecoration decoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(3)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 3,
          offset: Offset(0, 2), // changes position of shadow
        ),
      ],
    );
    if (noBorder) {
      decoration = BoxDecoration(
        color: Colors.white,
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: decoration,
        child: Column(
          children: [
            hideTitle ? Container() : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                title == null
                    ? titleWidget ?? Container()
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          icon == null
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: icon,
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0, left: 8.0, bottom: 4.0),
                            child: Text(title!, style: TextStyle(color: Color(0xff757575))),
                          ),
                        ],
                      ),
                onClose == null
                    ? Container()
                    : InkWell(
                        onTap: this.onClose,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                          child: Icon(Icons.close),
                        ),
                      ),
              ],
            ),
            child,
          ],
        ),
      ),
    );
  }
}
