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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TutoItem extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final String label;
  final void Function() action;

  const TutoItem(
      {Key? key,
      required this.image,
      required this.title,
      required this.description,
      required this.label,
      required this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.action,
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10,),
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFDBDBDB)),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
        children: [
            Container(
              width: 110,
              height: 120,
              alignment: Alignment.center, // This is needed
              child: this.image.endsWith('svg') ?
                        SvgPicture.asset(this.image, fit: BoxFit.contain,
                          width: 70, height: 80,) :
                        Image.asset(this.image, fit: BoxFit.contain,
                          width: 70, height: 80,),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10, top: 10,),
                    child: Text(
                      this.title,
                      style: TextStyle(
                        color: Color(0xff5B5B5B),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,

                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 5),
                    child: Text(
                      this.description,
                      maxLines: 10,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 5, right: 5,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          this.label,
                          style: TextStyle(
                            color: Color(0xff909090)
                          ),
                        ),
                    ],
                    ),
                  ),
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}
