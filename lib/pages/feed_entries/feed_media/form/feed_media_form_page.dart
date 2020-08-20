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

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:super_green_app/data/rel/feed/feeds.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/common/feed_entry_draft.dart';
import 'package:super_green_app/pages/feed_entries/feed_media/form/feed_media_form_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_date_picker.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_layout.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_media_list.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_param_layout.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_textarea.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class FeedMediaDraft extends FeedEntryDraftState {
  final int time;
  final List<MediaDraftState> medias;
  final String message;
  final bool helpRequest;

  FeedMediaDraft(
      int draftID, this.time, this.medias, this.message, this.helpRequest)
      : super(draftID);

  factory FeedMediaDraft.fromJSON(int draftID, String json) {
    Map<String, dynamic> map = JsonDecoder().convert(json);
    return FeedMediaDraft(
      draftID,
      map['time'],
      map['medias']
          .map<MediaDraftState>((m) => MediaDraftState.fromMap(m))
          .toList(),
      map['message'],
      map['helpRequest'],
    );
  }

  @override
  String toJSON() {
    return JsonEncoder().convert({
      'time': time,
      'medias': medias.map<Map<String, dynamic>>((m) => m.toMap()).toList(),
      'message': message,
      'helpRequest': helpRequest,
    });
  }

  @override
  List<Object> get props => [medias, message];

  @override
  FeedMediaDraft copyWithDraftID(int draftID) {
    return FeedMediaDraft(draftID, time, medias, message, helpRequest);
  }
}

class FeedMediaFormPage extends StatefulWidget {
  @override
  _FeedMediaFormPageState createState() => _FeedMediaFormPageState();
}

class _FeedMediaFormPageState extends State<FeedMediaFormPage> {
  DateTime date = DateTime.now();
  final List<FeedMediasCompanion> _medias = [];
  final TextEditingController _textController = TextEditingController();

  bool _helpRequest = false;

  Timer _saveDraftTimer;

  FeedMediaDraft draft;

  KeyboardVisibilityNotification _keyboardVisibility =
      KeyboardVisibilityNotification();
  int _listener;
  bool _keyboardVisible = false;

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

    _textController.addListener(() {
      if (_saveDraftTimer != null) {
        _saveDraftTimer.cancel();
      }
      _saveDraftTimer = Timer(Duration(seconds: 1), () {
        _saveDraft();
        _saveDraftTimer = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        cubit: BlocProvider.of<FeedMediaFormBloc>(context),
        listener: (BuildContext context, FeedMediaFormBlocState state) {
          if (state is FeedMediaFormBlocStateDraft) {
            _resumeDraft(context, state.draft);
          } else if (state is FeedMediaFormBlocStateCurrentDraft) {
            draft = state.draft;
          } else if (state is FeedMediaFormBlocStateDone) {
            BlocProvider.of<MainNavigatorBloc>(context)
                .add(MainNavigatorActionPop(mustPop: true));
          }
        },
        child: BlocBuilder<FeedMediaFormBloc, FeedMediaFormBlocState>(
            cubit: BlocProvider.of<FeedMediaFormBloc>(context),
            buildWhen: (FeedMediaFormBlocState beforeState,
                FeedMediaFormBlocState afterState) {
              return afterState is FeedMediaFormBlocStateLoading ||
                  afterState is FeedMediaFormBlocStateDone ||
                  afterState is FeedMediaFormBlocState;
            },
            builder: (context, state) {
              String title = '🧐';
              Widget body;
              if (state is FeedMediaFormBlocStateLoading) {
                body = Scaffold(
                    appBar: SGLAppBar(
                      title,
                      fontSize: 35,
                    ),
                    body: FullscreenLoading(title: 'Saving..'));
              } else if (state is FeedMediaFormBlocStateDone) {
                body = Scaffold(
                    appBar: SGLAppBar(
                      title,
                      fontSize: 35,
                    ),
                    body: Fullscreen(
                      title: 'Done!',
                      child: Icon(Icons.check, color: Colors.green),
                    ));
              } else {
                body = FeedFormLayout(
                  title: title,
                  fontSize: 35,
                  changed:
                      _medias.length != 0 || _textController.value.text != '',
                  valid:
                      _medias.length != 0 || _textController.value.text != '',
                  onOK: () => BlocProvider.of<FeedMediaFormBloc>(context).add(
                      FeedMediaFormBlocEventCreate(date, _medias,
                          _textController.text, _helpRequest, draft)),
                  onCancel: () async {
                    for (FeedMediasCompanion media in _medias) {
                      await _deleteFileIfExists(media.filePath.value);
                      await _deleteFileIfExists(media.thumbnailPath.value);
                    }
                    if (draft != null) {
                      BlocProvider.of<FeedMediaFormBloc>(context)
                          .add(FeedMediaFormBlocEventDeleteDraft(draft));
                    }
                  },
                  body: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: _keyboardVisible
                          ? [_renderTextrea(context, state)]
                          : _renderBody(context, state)),
                );
              }
              return AnimatedSwitcher(
                  duration: Duration(milliseconds: 200), child: body);
            }));
  }

  List<Widget> _renderBody(BuildContext context, FeedMediaFormBlocState state) {
    return [
      FeedFormDatePicker(
        date,
        onChange: (DateTime newDate) {
          setState(() {
            date = newDate;
            _saveDraft();
          });
        },
      ),
      FeedFormParamLayout(
        title: 'Attached medias',
        icon: 'assets/feed_form/icon_after_pic.svg',
        child: FeedFormMediaList(
          medias: _medias,
          onLongPressed: (FeedMediasCompanion media) async {
            bool confirm = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Delete this pic?'),
                    content: Text('This can\'t be reverted. Continue?'),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: Text('NO'),
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: Text('YES'),
                      ),
                    ],
                  );
                });
            if (confirm) {
              setState(() {
                _medias.remove(media);
                _saveDraft();
              });
            }
          },
          onPressed: (FeedMediasCompanion media) async {
            if (media == null) {
              List<FeedMediasCompanion> feedMedias = await _takePic(context);
              if (feedMedias != null) {
                setState(() {
                  _medias.addAll(feedMedias);
                  _saveDraft();
                });
              }
            } else {
              FutureFn ff =
                  BlocProvider.of<MainNavigatorBloc>(context).futureFn();
              BlocProvider.of<MainNavigatorBloc>(context).add(
                  MainNavigateToImageCapturePlaybackEvent(media.filePath.value,
                      futureFn: ff.futureFn, okButton: 'OK'));
              bool keep = await ff.future;
              if (keep == true) {
              } else if (keep == false) {
                List<FeedMediasCompanion> feedMedias = await _takePic(context);
                if (feedMedias != null) {
                  setState(() {
                    int i = _medias.indexOf(media);
                    _medias.replaceRange(i, i + 1, feedMedias);
                    _saveDraft();
                  });
                }
              }
            }
          },
        ),
      ),
      _renderTextrea(context, state),
      _renderOptions(context, state),
    ];
  }

  Future<List<FeedMediasCompanion>> _takePic(BuildContext context) async {
    FutureFn futureFn = BlocProvider.of<MainNavigatorBloc>(context).futureFn();
    BlocProvider.of<MainNavigatorBloc>(context)
        .add(MainNavigateToImageCaptureEvent(futureFn: futureFn.futureFn));
    List<FeedMediasCompanion> feedMedias = await futureFn.future;
    return feedMedias;
  }

  Widget _renderTextrea(BuildContext context, FeedMediaFormBlocState state) {
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

  Widget _renderOptions(BuildContext context, FeedMediaFormBlocState state) {
    return Row(
      children: <Widget>[
        _renderOptionCheckbx(context, state, 'Help request?', (bool newValue) {
          setState(() {
            _helpRequest = newValue;
          });
        }, _helpRequest),
      ],
    );
  }

  Widget _renderOptionCheckbx(
      BuildContext context,
      FeedMediaFormBlocState state,
      String text,
      Function onChanged,
      bool value) {
    return Row(
      children: <Widget>[
        Checkbox(
          onChanged: onChanged,
          value: value,
        ),
        Text(text),
      ],
    );
  }

  void _resumeDraft(BuildContext context, FeedMediaDraft newDraft) async {
    bool confirm = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Draft recovery'),
            content: Text('Resume previous grow log?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text('NO'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text('YES'),
              ),
            ],
          );
        });
    if (confirm == false) {
      for (MediaDraftState media in newDraft.medias) {
        await _deleteFileIfExists(media.filePath);
        await _deleteFileIfExists(media.thumbnailPath);
      }
      BlocProvider.of<FeedMediaFormBloc>(context)
          .add(FeedMediaFormBlocEventDeleteDraft(newDraft));
    } else {
      draft = newDraft;
      setState(() {
        date = DateTime.fromMillisecondsSinceEpoch(draft.time * 1000);
        _medias
            .addAll(draft.medias.map((e) => e.toFeedMediaCompanion()).toList());
        _textController.text = draft.message;
        _helpRequest = draft.helpRequest;
      });
    }
  }

  void _saveDraft() {
    draft = FeedMediaDraft(
        draft?.draftID,
        date.millisecondsSinceEpoch ~/ 1000,
        _medias
            .map<MediaDraftState>(
                (e) => MediaDraftState.fromFeedMediaCompanion(e))
            .toList(),
        _textController.text,
        _helpRequest);
    BlocProvider.of<FeedMediaFormBloc>(context)
        .add(FeedMediaFormBlocEventSaveDraft(draft));
  }

  Future _deleteFileIfExists(String filePath) async {
    final File file = File(FeedMedias.makeAbsoluteFilePath(filePath));
    try {
      await file.delete();
    } catch (e) {}
  }

  @override
  void dispose() {
    _keyboardVisibility.removeListener(_listener);
    _textController.dispose();
    super.dispose();
  }
}
