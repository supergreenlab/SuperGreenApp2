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
import 'package:flutter_svg/flutter_svg.dart';

class SectionTitle extends StatefulWidget {
  final String title;
  final String icon;
  final Color? backgroundColor;
  final Color? titleColor;
  final bool large;
  final double? elevation;
  final double iconPadding;
  final Widget? child;
  final Function(String)? onTitleEdited;
  final bool bold;

  const SectionTitle({
    required this.title,
    required this.icon,
    this.large = false,
    this.backgroundColor,
    this.titleColor = Colors.black,
    this.elevation,
    this.iconPadding = 8,
    this.child,
    this.onTitleEdited,
    this.bold = false,
  });

  @override
  _SectionTitleState createState() => _SectionTitleState();
}

class _SectionTitleState extends State<SectionTitle> {
  bool _isEditing = false;
  late TextEditingController _titleController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSubmitted(String value) {
    if (_isEditing) {
      widget.onTitleEdited!(value);
      setState(() {
        _isEditing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: widget.elevation != null
            ? [BoxShadow(offset: Offset(0, widget.elevation!), color: Colors.black12, blurRadius: widget.elevation!)]
            : null,
        color: widget.backgroundColor ?? Color(0xFFECECEC),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.0, vertical: widget.large ? 16.0 : 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _renderIcon(),
            Expanded(
              child: _isEditing
                  ? TextField(
                      controller: _titleController,
                      focusNode: _focusNode,
                      style: TextStyle(
                        fontWeight: widget.bold ? FontWeight.bold : FontWeight.w300,
                        fontSize: widget.large ? 20 : 16,
                        color: widget.titleColor,
                      ),
                      decoration: InputDecoration(
                        hintText: 'ex: Top light',
                        border: InputBorder.none,
                      ),
                      onSubmitted: _handleSubmitted,
                    )
                  : Text(
                      widget.title,
                      style: TextStyle(
                        fontWeight: widget.bold ? FontWeight.bold : FontWeight.w300,
                        fontSize: widget.large ? 20 : 16,
                        color: widget.titleColor,
                      ),
                    ),
            ),
            if (widget.onTitleEdited != null)
              IconButton(
                icon: Icon(_isEditing ? Icons.check : Icons.edit, color: _isEditing ? Colors.green : null),
                onPressed: () {
                  setState(() {
                    if (_isEditing) {
                      _handleSubmitted(_titleController.text);
                    } else {
                      _isEditing = true;
                      // Schedule focus for the next frame
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        FocusScope.of(context).requestFocus(_focusNode);
                      });
                    }
                  });
                },
              ),
            if (widget.child != null && !_isEditing)
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: widget.child,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _renderIcon() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, left: 4.0),
      child: Container(
        width: widget.large ? 50 : 40,
        height: widget.large ? 50 : 40,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(25))),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: widget.iconPadding, horizontal: widget.iconPadding),
          child: SvgPicture.asset(widget.icon),
        ),
      ),
    );
  }
}

