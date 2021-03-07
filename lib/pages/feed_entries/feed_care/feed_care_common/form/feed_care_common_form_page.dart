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
import 'package:intl/intl.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:super_green_app/data/rel/feed/feeds.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/l10n/common.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/common/feed_entry_draft.dart';
import 'package:super_green_app/pages/feed_entries/feed_care/feed_care_common/form/feed_care_common_form_bloc.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_date_picker.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_layout.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_media_list.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_param_layout.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_textarea.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class FeedCareCommonDraft extends FeedEntryDraftState {
  final int time;
  final List<MediaDraftState> beforeMedias;
  final List<MediaDraftState> afterMedias;
  final String message;

  FeedCareCommonDraft(int draftID, this.time, this.beforeMedias, this.afterMedias, this.message) : super(draftID);

  factory FeedCareCommonDraft.fromJSON(int draftID, String json) {
    Map<String, dynamic> map = JsonDecoder().convert(json);
    return FeedCareCommonDraft(
      draftID,
      map['time'],
      map['beforeMedias'].map<MediaDraftState>((bm) => MediaDraftState.fromMap(bm)).toList(),
      map['afterMedias'].map<MediaDraftState>((am) => MediaDraftState.fromMap(am)).toList(),
      map['message'],
    );
  }

  @override
  String toJSON() {
    return JsonEncoder().convert({
      'time': time,
      'beforeMedias': beforeMedias.map<Map<String, dynamic>>((bm) => bm.toMap()).toList(),
      'afterMedias': afterMedias.map<Map<String, dynamic>>((am) => am.toMap()).toList(),
      'message': message,
    });
  }

  @override
  List<Object> get props => [beforeMedias, afterMedias, message];

  @override
  FeedCareCommonDraft copyWithDraftID(int draftID) {
    return FeedCareCommonDraft(draftID, time, beforeMedias, afterMedias, message);
  }
}

abstract class FeedCareCommonFormPage<FormBloc extends FeedCareCommonFormBloc> extends StatefulWidget {
  static String get feedCareCommonFormSaving {
    return Intl.message(
      'Saving..',
      name: 'feedCareCommonFormSaving',
      desc: 'Displayd as a fullscreen loading',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get feedCareCommonBeforePics {
    return Intl.message(
      'Before pics',
      name: 'feedCareCommonBeforePics',
      desc: 'Title for the "before pics" list',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get feedCareCommonAfterPics {
    return Intl.message(
      'After pics',
      name: 'feedCareCommonAfterPics',
      desc: 'Title for the "after pics" list',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get feedCareCommonDeletePicDialogTitle {
    return Intl.message(
      'Delete this pic?',
      name: 'feedCareCommonDeletePicDialogTitle',
      desc: 'Title for the pic deletion confirmation dialog',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get feedCareCommonDeletePicDialogBody {
    return Intl.message(
      'This can\'t be reverted. Continue?',
      name: 'feedCareCommonDeletePicDialogBody',
      desc: 'Body for the pic deletion confirmation dialog',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get feedCareCommonObservations {
    return Intl.message(
      'Observations',
      name: 'feedCareCommonObservations',
      desc: 'Observations field label',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get feedCareCommonDraftRecoveryDialogTitle {
    return Intl.message(
      'Draft recovery',
      name: 'feedCareCommonDraftRecoveryDialogTitle',
      desc: 'Draft recovery dialog title',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String feedCareCommonDraftRecoveryDialogBody(String title) {
    return Intl.message(
      'Resume previous $title card draft?',
      args: [title],
      name: 'feedCareCommonDraftRecoveryDialogBody',
      desc: 'Draft recovery dialog body',
      locale: SGLLocalizations.current.localeName,
    );
  }

  @override
  _FeedCareCommonFormPageState<FormBloc> createState() => _FeedCareCommonFormPageState<FormBloc>(title());

  String title();
}

class _FeedCareCommonFormPageState<FormBloc extends FeedCareCommonFormBloc> extends State<FeedCareCommonFormPage> {
  DateTime date = DateTime.now();

  final String title;
  final List<FeedMediasCompanion> _beforeMedias = [];
  final List<FeedMediasCompanion> _afterMedias = [];
  final TextEditingController _textController = TextEditingController();

  Timer _saveDraftTimer;

  FeedCareCommonDraft draft;

  bool _helpRequest = false;

  KeyboardVisibilityNotification _keyboardVisibility = KeyboardVisibilityNotification();
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
        cubit: BlocProvider.of<FormBloc>(context),
        listener: (BuildContext context, FeedCareCommonFormBlocState state) {
          if (state is FeedCareCommonFormBlocStateDraft) {
            _resumeDraft(context, state.draft);
          } else if (state is FeedCareCommonFormBlocStateCurrentDraft) {
            draft = state.draft;
          } else if (state is FeedCareCommonFormBlocStateDone) {
            BlocProvider.of<TowelieBloc>(context).add(TowelieBlocEventFeedEntryCreated(state.plant, state.feedEntry));
            BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop(mustPop: true));
          }
        },
        child: BlocBuilder<FeedCareCommonFormBloc, FeedCareCommonFormBlocState>(
            cubit: BlocProvider.of<FormBloc>(context),
            buildWhen: (FeedCareCommonFormBlocState beforeState, FeedCareCommonFormBlocState afterState) {
              return afterState is FeedCareCommonFormBlocStateLoading ||
                  afterState is FeedCareCommonFormBlocStateDone ||
                  afterState is FeedCareCommonFormBlocState;
            },
            builder: (context, state) {
              Widget body;
              if (state is FeedCareCommonFormBlocStateLoading) {
                body = Scaffold(
                    appBar: SGLAppBar(
                      title,
                      fontSize: 35,
                    ),
                    body: FullscreenLoading(title: FeedCareCommonFormPage.feedCareCommonFormSaving));
              } else if (state is FeedCareCommonFormBlocStateDone) {
                body = Scaffold(
                    appBar: SGLAppBar(
                      title,
                      fontSize: 35,
                    ),
                    body: Fullscreen(
                      title: FeedCareCommonFormPage.feedCareCommonFormSaving,
                      child: Icon(Icons.check, color: Colors.green),
                    ));
              } else {
                body = FeedFormLayout(
                  title: title,
                  fontSize: 35,
                  changed: _afterMedias.length != 0 || _beforeMedias.length != 0 || _textController.value.text != '',
                  valid: _afterMedias.length != 0 || _beforeMedias.length != 0 || _textController.value.text != '',
                  onOK: () => BlocProvider.of<FormBloc>(context).add(FeedCareCommonFormBlocEventCreate(
                      date, _beforeMedias, _afterMedias, _textController.text, _helpRequest, draft)),
                  onCancel: () async {
                    for (FeedMediasCompanion media in _beforeMedias) {
                      await _deleteFileIfExists(media.filePath.value);
                      await _deleteFileIfExists(media.thumbnailPath.value);
                    }
                    for (FeedMediasCompanion media in _afterMedias) {
                      await _deleteFileIfExists(media.filePath.value);
                      await _deleteFileIfExists(media.thumbnailPath.value);
                    }
                    if (draft != null) {
                      BlocProvider.of<FormBloc>(context).add(FeedCareCommonFormBlocEventDeleteDraft(draft));
                    }
                  },
                  body: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: _keyboardVisible ? [_renderTextrea(context, state)] : _renderBody(context, state)),
                );
              }
              return AnimatedSwitcher(duration: Duration(milliseconds: 200), child: body);
            }));
  }

  List<Widget> _renderBody(BuildContext context, FeedCareCommonFormBlocState state) {
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
        title: FeedCareCommonFormPage.feedCareCommonBeforePics,
        icon: 'assets/feed_form/icon_before_pic.svg',
        child: FeedFormMediaList(
          medias: _beforeMedias,
          onLongPressed: (FeedMediasCompanion media) async {
            bool confirm = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(FeedCareCommonFormPage.feedCareCommonDeletePicDialogTitle),
                    content: Text(FeedCareCommonFormPage.feedCareCommonDeletePicDialogBody),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: Text(CommonL10N.no),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: Text(CommonL10N.yes),
                      ),
                    ],
                  );
                });
            if (confirm) {
              setState(() {
                _deleteFileIfExists(media.filePath.value);
                _deleteFileIfExists(media.thumbnailPath.value);
                _beforeMedias.remove(media);
                _saveDraft();
              });
            }
          },
          onPressed: (FeedMediasCompanion media) async {
            if (media == null) {
              BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToImageCaptureEvent(futureFn: (f) async {
                List<FeedMediasCompanion> feedMedias = await f;
                if (feedMedias != null) {
                  setState(() {
                    _beforeMedias.addAll(feedMedias);
                    _saveDraft();
                  });
                }
              }));
            } else {
              FutureFn ff = BlocProvider.of<MainNavigatorBloc>(context).futureFn();
              BlocProvider.of<MainNavigatorBloc>(context).add(
                  MainNavigateToImageCapturePlaybackEvent(media.filePath.value, futureFn: ff.futureFn, okButton: 'OK'));
              bool keep = await ff.future;
              if (keep == true) {
              } else if (keep == false) {
                List<FeedMediasCompanion> feedMedias = await _takePic(context);
                if (feedMedias != null) {
                  setState(() {
                    int i = _beforeMedias.indexOf(media);
                    _beforeMedias.replaceRange(i, i + 1, feedMedias);
                    _saveDraft();
                  });
                }
              }
            }
          },
        ),
      ),
      FeedFormParamLayout(
        title: FeedCareCommonFormPage.feedCareCommonAfterPics,
        icon: 'assets/feed_form/icon_after_pic.svg',
        child: FeedFormMediaList(
          medias: _afterMedias,
          onLongPressed: (FeedMediasCompanion media) async {
            bool confirm = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(FeedCareCommonFormPage.feedCareCommonDeletePicDialogTitle),
                    content: Text(FeedCareCommonFormPage.feedCareCommonDeletePicDialogBody),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: Text(CommonL10N.no),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: Text(CommonL10N.yes),
                      ),
                    ],
                  );
                });
            if (confirm) {
              setState(() {
                _deleteFileIfExists(media.filePath.value);
                _deleteFileIfExists(media.thumbnailPath.value);
                _afterMedias.remove(media);
                _saveDraft();
              });
            }
          },
          onPressed: (FeedMediasCompanion media) async {
            if (media == null) {
              BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToImageCaptureEvent(futureFn: (f) async {
                List<FeedMediasCompanion> feedMedias = await f;
                if (feedMedias != null) {
                  setState(() {
                    _afterMedias.addAll(feedMedias);
                    _saveDraft();
                  });
                }
              }));
            } else {
              FutureFn ff = BlocProvider.of<MainNavigatorBloc>(context).futureFn();
              BlocProvider.of<MainNavigatorBloc>(context).add(
                  MainNavigateToImageCapturePlaybackEvent(media.filePath.value, futureFn: ff.futureFn, okButton: 'OK'));
              bool keep = await ff.future;
              if (keep == true) {
              } else if (keep == false) {
                List<FeedMediasCompanion> feedMedias = await _takePic(context);
                if (feedMedias != null) {
                  setState(() {
                    int i = _afterMedias.indexOf(media);
                    _afterMedias.replaceRange(i, i + 1, feedMedias);
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
    BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToImageCaptureEvent(futureFn: futureFn.futureFn));
    List<FeedMediasCompanion> feedMedias = await futureFn.future;
    return feedMedias;
  }

  Widget _renderTextrea(BuildContext context, FeedCareCommonFormBlocState state) {
    return Expanded(
      key: Key('TEXTAREA'),
      child: FeedFormParamLayout(
        title: FeedCareCommonFormPage.feedCareCommonObservations,
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

  void _resumeDraft(BuildContext context, FeedCareCommonDraft newDraft) async {
    bool confirm = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(FeedCareCommonFormPage.feedCareCommonDraftRecoveryDialogTitle),
            content: Text(FeedCareCommonFormPage.feedCareCommonDraftRecoveryDialogBody(widget.title())),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text(CommonL10N.no),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text(CommonL10N.yes),
              ),
            ],
          );
        });
    if (confirm == false) {
      for (MediaDraftState media in newDraft.beforeMedias) {
        await _deleteFileIfExists(media.filePath);
        await _deleteFileIfExists(media.thumbnailPath);
      }
      for (MediaDraftState media in newDraft.afterMedias) {
        await _deleteFileIfExists(media.filePath);
        await _deleteFileIfExists(media.thumbnailPath);
      }
      BlocProvider.of<FormBloc>(context).add(FeedCareCommonFormBlocEventDeleteDraft(newDraft));
    } else {
      draft = newDraft;
      setState(() {
        date = DateTime.fromMillisecondsSinceEpoch(draft.time * 1000);
        _beforeMedias.addAll(draft.beforeMedias.map((e) => e.toFeedMediaCompanion()).toList());
        _afterMedias.addAll(draft.afterMedias.map((e) => e.toFeedMediaCompanion()).toList());
        _textController.text = draft.message;
      });
    }
  }

  void _saveDraft() {
    draft = FeedCareCommonDraft(
        draft?.draftID,
        date.millisecondsSinceEpoch ~/ 1000,
        _beforeMedias.map<MediaDraftState>((e) => MediaDraftState.fromFeedMediaCompanion(e)).toList(),
        _afterMedias.map<MediaDraftState>((e) => MediaDraftState.fromFeedMediaCompanion(e)).toList(),
        _textController.text);
    BlocProvider.of<FormBloc>(context).add(FeedCareCommonFormBlocEventSaveDraft(draft));
  }

  Future _deleteFileIfExists(String filePath) async {
    final File file = File(FeedMedias.makeAbsoluteFilePath(filePath));
    try {
      await file.delete();
    } catch (e) {}
  }

  @override
  void dispose() {
    if (_saveDraftTimer != null) {
      _saveDraftTimer.cancel();
    }
    _keyboardVisibility.removeListener(_listener);
    _textController.dispose();
    super.dispose();
  }
}
