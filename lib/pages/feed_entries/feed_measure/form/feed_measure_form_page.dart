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
import 'package:intl/intl.dart';
import 'package:super_green_app/l10n.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:super_green_app/data/rel/feed/feeds.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n/common.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_measure/form/feed_measure_form_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_measure/form/feed_measure_previous_selector.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_layout.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_media_list.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_param_layout.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_textarea.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class FeedMeasureFormPage extends StatefulWidget {
  static String get feedMeasureFormPagePreviousMeasure {
    return Intl.message(
      'Previous measures',
      name: 'feedMeasureFormPagePreviousMeasure',
      desc: 'Title for the previous measure selection',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get feedMeasureFormPageUnselectMeasureDialogTitle {
    return Intl.message(
      'Unselect this measure?',
      name: 'feedMeasureFormPageUnselectMeasureDialogTitle',
      desc: 'Title for the cancel previous measure dialog',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get feedMeasureFormPageTodayMeasure {
    return Intl.message(
      'Today\'s measure',
      name: 'feedMeasureFormPageTodayMeasure',
      desc: 'Title for the today measure selection',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get feedMeasureFormPageDeletePicDialogTitle {
    return Intl.message(
      'Delete this pic?',
      name: 'feedMeasureFormPageDeletePicDialogTitle',
      desc: 'Title for the delete measure dialog',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get feedMeasureFormPageObservations {
    return Intl.message(
      'Observations',
      name: 'feedMeasureFormPageObservations',
      desc: 'Observation field label',
      locale: SGLLocalizations.current.localeName,
    );
  }

  @override
  _FeedMeasureFormPageState createState() => _FeedMeasureFormPageState();
}

class _FeedMeasureFormPageState extends State<FeedMeasureFormPage> {
  FeedMedia _previous;
  FeedMediasCompanion _media;
  final TextEditingController _textController = TextEditingController();

  bool _showSelector = false;

  KeyboardVisibilityNotification _keyboardVisibility = KeyboardVisibilityNotification();
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
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_showSelector) {
          setState(() {
            _showSelector = false;
          });
          return false;
        }
        return true;
      },
      child: BlocListener(
          cubit: BlocProvider.of<FeedMeasureFormBloc>(context),
          listener: (BuildContext context, FeedMeasureFormBlocState state) {
            if (state is FeedMeasureFormBlocStateDone) {
              BlocProvider.of<TowelieBloc>(context).add(TowelieBlocEventFeedEntryCreated(state.plant, state.feedEntry));
              BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop(mustPop: true));
            }
          },
          child: BlocBuilder<FeedMeasureFormBloc, FeedMeasureFormBlocState>(
              cubit: BlocProvider.of<FeedMeasureFormBloc>(context),
              builder: (context, state) {
                String title = '🍌';
                Widget body;
                if (_showSelector && state is FeedMeasureFormBlocStateLoaded) {
                  body = FeedMeasurePreviousSelector(state.measures, (FeedMedia fm) {
                    setState(() {
                      _previous = fm;
                      _showSelector = false;
                    });
                  });
                } else if (state is FeedMeasureFormBlocStateInit) {
                  body = Scaffold(
                      appBar: SGLAppBar(
                        title,
                        fontSize: 35,
                      ),
                      body: FullscreenLoading(title: 'Loading..'));
                } else if (state is FeedMeasureFormBlocStateLoading) {
                  body = Scaffold(
                      appBar: SGLAppBar(
                        title,
                        fontSize: 35,
                      ),
                      body: FullscreenLoading(title: 'Saving..'));
                } else if (state is FeedMeasureFormBlocStateDone) {
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
                      changed: _previous != null || _media != null,
                      valid: _media != null,
                      onOK: () => BlocProvider.of<FeedMeasureFormBloc>(context)
                          .add(FeedMeasureFormBlocEventCreate(_textController.text, _previous, _media)),
                      body: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: _keyboardVisible ? [_renderTextrea(context, state)] : _renderBody(context, state)));
                }
                return AnimatedSwitcher(duration: Duration(milliseconds: 200), child: body);
              })),
    );
  }

  List<Widget> _renderBody(BuildContext context, FeedMeasureFormBlocStateLoaded state) {
    List<Widget> content = [_renderCurrent(context)];
    if (state.measures.length > 0) {
      content.insert(
        0,
        _renderPrevious(context),
      );
    }
    content.add(_renderTextrea(context, state));
    return content;
  }

  Widget _renderPrevious(BuildContext context) {
    return FeedFormParamLayout(
      title: FeedMeasureFormPage.feedMeasureFormPagePreviousMeasure,
      icon: 'assets/feed_form/icon_after_pic.svg',
      child: FeedFormMediaList(
        maxMedias: 1,
        medias: _previous != null ? [FeedMedias.toCompanion(_previous)] : [],
        onLongPressed: (FeedMediasCompanion media) async {
          bool confirm = await showDialog<bool>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(FeedMeasureFormPage.feedMeasureFormPageUnselectMeasureDialogTitle),
                  content: Text(''),
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
              _previous = null;
            });
          }
        },
        onPressed: (FeedMediasCompanion media) async {
          if (media == null) {
            setState(() {
              _showSelector = true;
            });
          } else {
            FutureFn ff = BlocProvider.of<MainNavigatorBloc>(context).futureFn();
            BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToImageCapturePlaybackEvent(
                media.filePath.value,
                futureFn: ff.futureFn,
                okButton: CommonL10N.ok,
                cancelButton: CommonL10N.cancel));
            bool keep = await ff.future;
            if (keep == false) {
              setState(() {
                _showSelector = true;
              });
            }
          }
        },
      ),
    );
  }

  Future<FeedMediasCompanion> _takePic(BuildContext context) async {
    FutureFn futureFn = BlocProvider.of<MainNavigatorBloc>(context).futureFn();
    BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToImageCaptureEvent(
        futureFn: futureFn.futureFn, overlayPath: _previous?.filePath, videoEnabled: false, pickerEnabled: false));
    List<FeedMediasCompanion> fm = await futureFn.future;
    if (fm == null || fm.length == 0) {
      return null;
    }
    return fm[0];
  }

  Widget _renderCurrent(BuildContext context) {
    return FeedFormParamLayout(
      title: FeedMeasureFormPage.feedMeasureFormPageTodayMeasure,
      icon: 'assets/feed_form/icon_after_pic.svg',
      child: FeedFormMediaList(
        maxMedias: 1,
        medias: _media != null ? [_media] : [],
        onLongPressed: (FeedMediasCompanion media) async {
          bool confirm = await showDialog<bool>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(FeedMeasureFormPage.feedMeasureFormPageDeletePicDialogTitle),
                  content: Text(CommonL10N.confirmUnRevertableChange),
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
              _media = null;
            });
          }
        },
        onPressed: (FeedMediasCompanion media) async {
          if (media == null) {
            FeedMediasCompanion fm = await _takePic(context);
            if (fm != null) {
              setState(() {
                _media = fm;
              });
            }
          } else {
            FutureFn ff = BlocProvider.of<MainNavigatorBloc>(context).futureFn();
            BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToImageCapturePlaybackEvent(
                media.filePath.value,
                futureFn: ff.futureFn,
                overlayPath: _previous?.filePath,
                okButton: CommonL10N.ok));
            bool keep = await ff.future;
            if (keep == true) {
            } else if (keep == false) {
              FeedMediasCompanion fm = await _takePic(context);
              if (fm != null) {
                setState(() {
                  _media = fm;
                });
              }
            }
          }
        },
      ),
    );
  }

  Widget _renderTextrea(BuildContext context, FeedMeasureFormBlocState state) {
    return Expanded(
      key: Key('TEXTAREA'),
      child: FeedFormParamLayout(
        title: FeedMeasureFormPage.feedMeasureFormPageObservations,
        icon: 'assets/feed_form/icon_note.svg',
        child: Expanded(
          child: FeedFormTextarea(
            textEditingController: _textController,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _keyboardVisibility.removeListener(_listener);
    super.dispose();
  }
}
