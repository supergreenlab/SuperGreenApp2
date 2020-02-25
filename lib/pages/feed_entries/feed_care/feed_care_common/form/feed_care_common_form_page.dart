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
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_care/feed_care_common/form/feed_care_common_form_bloc.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_layout.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_media_list.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_param_layout.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_textarea.dart';

abstract class FeedCareCommonFormPage<FormBloc extends FeedCareCommonFormBloc>
    extends StatefulWidget {
  @override
  _FeedCareCommonFormPageState<FormBloc> createState() =>
      _FeedCareCommonFormPageState<FormBloc>(title());

  String title();
}

class _FeedCareCommonFormPageState<FormBloc extends FeedCareCommonFormBloc>
    extends State<FeedCareCommonFormPage> {
  final String title;
  final List<FeedMediasCompanion> _beforeMedias = [];
  final List<FeedMediasCompanion> _afterMedias = [];
  final TextEditingController _textController = TextEditingController();

  bool _helpRequest = false;

  KeyboardVisibilityNotification _keyboardVisibility =
      KeyboardVisibilityNotification();
  int _listener;
  bool _keyboardVisible = false;

  _FeedCareCommonFormPageState(this.title);

  @protected
  void initState() {
    super.initState();

    _listener = _keyboardVisibility.addNewListener(
      onChange: (bool visible) {
        setState(() {
          _keyboardVisible = visible;
        });
        if (!_keyboardVisible) {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: BlocProvider.of<FormBloc>(context),
        listener: (BuildContext context, FeedCareCommonFormBlocState state) {
          if (state is FeedCareCommonFormBlocStateDone) {
            BlocProvider.of<MainNavigatorBloc>(context)
                .add(MainNavigatorActionPop(mustPop: true));
          }
        },
        child: BlocBuilder<FeedCareCommonFormBloc, FeedCareCommonFormBlocState>(
          bloc: BlocProvider.of<FormBloc>(context),
          builder: (context, state) => FeedFormLayout(
            title: title,
            changed: _afterMedias.length != 0 ||
                _beforeMedias.length != 0 ||
                _textController.value.text != '',
            valid: _afterMedias.length != 0 ||
                _beforeMedias.length != 0 ||
                _textController.value.text != '',
            onOK: () => BlocProvider.of<FormBloc>(context).add(
                FeedCareCommonFormBlocEventCreate(_beforeMedias, _afterMedias,
                    _textController.text, _helpRequest)),
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _keyboardVisible
                    ? [_renderTextrea(context, state)]
                    : _renderBody(context, state)),
          ),
        ));
  }

  List<Widget> _renderBody(
      BuildContext context, FeedCareCommonFormBlocState state) {
    return [
      FeedFormParamLayout(
        title: 'Before pics',
        icon: 'assets/feed_form/icon_before_pic.svg',
        child: FeedFormMediaList(
          medias: _beforeMedias,
          onPressed: (FeedMediasCompanion media) {
            if (media == null) {
              BlocProvider.of<MainNavigatorBloc>(context)
                  .add(MainNavigateToImageCaptureEvent(futureFn: (f) async {
                FeedMediasCompanion fm = await f;
                if (fm != null) {
                  setState(() {
                    _beforeMedias.add(fm);
                  }); // Why? no idea, but it wont refresh on bloc's state change without that.
                }
              }));
            }
          },
        ),
      ),
      FeedFormParamLayout(
        title: 'After pics',
        icon: 'assets/feed_form/icon_after_pic.svg',
        child: FeedFormMediaList(
          medias: _afterMedias,
          onPressed: (FeedMediasCompanion media) {
            if (media == null) {
              BlocProvider.of<MainNavigatorBloc>(context)
                  .add(MainNavigateToImageCaptureEvent(futureFn: (f) async {
                FeedMediasCompanion fm = await f;
                if (fm != null) {
                  setState(() {
                    _afterMedias.add(fm);
                  });
                }
              }));
            }
          },
        ),
      ),
      _renderTextrea(context, state),
      _renderOptions(context, state),
    ];
  }

  Widget _renderTextrea(BuildContext context, FeedCareCommonFormBlocState state) {
    return Expanded(
      key: Key('TEXTAREA'),
      child: FeedFormParamLayout(
        title: 'Observations',
        icon: 'assets/feed_form/icon_note.svg',
        child: Expanded(
          child: FeedFormTextarea(
            textEditingController: _textController,
          ),
        ),
      ),
    );
  }

  Widget _renderOptions(BuildContext context, FeedCareCommonFormBlocState state) {
    return Row(
      children: <Widget>[],
    );
  }

  @override
  void dispose() {
    _keyboardVisibility.removeListener(_listener);
    _textController.dispose();
    super.dispose();
  }
}
