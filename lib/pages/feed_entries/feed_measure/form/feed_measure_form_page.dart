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
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_measure/form/feed_measure_form_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_measure/form/feed_measure_previous_selector.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_layout.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_media_list.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_param_layout.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class FeedMeasureFormPage extends StatefulWidget {
  @override
  _FeedMeasureFormPageState createState() => _FeedMeasureFormPageState();
}

class _FeedMeasureFormPageState extends State<FeedMeasureFormPage> {
  FeedMedia _previous;
  FeedMediasCompanion _media;

  bool _showSelector = false;

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
          bloc: BlocProvider.of<FeedMeasureFormBloc>(context),
          listener: (BuildContext context, FeedMeasureFormBlocState state) {
            if (state is FeedMeasureFormBlocStateDone) {
              BlocProvider.of<TowelieBloc>(context).add(
                  TowelieBlocEventFeedEntryCreated(
                      state.plant, state.feedEntry));
              BlocProvider.of<MainNavigatorBloc>(context)
                  .add(MainNavigatorActionPop(mustPop: true));
            }
          },
          child: BlocBuilder<FeedMeasureFormBloc, FeedMeasureFormBlocState>(
              bloc: BlocProvider.of<FeedMeasureFormBloc>(context),
              builder: (context, state) {
                String title = '🍌';
                Widget body;
                if (_showSelector && state is FeedMeasureFormBlocStateLoaded) {
                  body = FeedMeasurePreviousSelector(state.measures,
                      (FeedMedia fm) {
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
                          .add(FeedMeasureFormBlocEventCreate(
                              _previous, _media)),
                      body: _renderBody(context, state));
                }
                return AnimatedSwitcher(
                    duration: Duration(milliseconds: 200), child: body);
              })),
    );
  }

  Widget _renderBody(
      BuildContext context, FeedMeasureFormBlocStateLoaded state) {
    List<Widget> content = [_renderCurrent(context)];
    if (state.measures.length > 0) {
      content.insert(
        0,
        _renderPrevious(context),
      );
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, children: content);
  }

  Widget _renderPrevious(BuildContext context) {
    return FeedFormParamLayout(
      title: 'Previous measures',
      icon: 'assets/feed_form/icon_after_pic.svg',
      child: FeedFormMediaList(
        maxMedias: 1,
        medias: _previous != null ? [_previous.createCompanion(true)] : [],
        onLongPressed: (FeedMediasCompanion media) async {
          bool confirm = await showDialog<bool>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Unselect this measure?'),
                  content: Text(''),
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
            FutureFn ff =
                BlocProvider.of<MainNavigatorBloc>(context).futureFn();
            BlocProvider.of<MainNavigatorBloc>(context).add(
                MainNavigateToImageCapturePlaybackEvent(media.filePath.value,
                    futureFn: ff.futureFn,
                    okButton: 'OK',
                    cancelButton: 'CHANGE'));
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
    BlocProvider.of<MainNavigatorBloc>(context).add(
        MainNavigateToImageCaptureEvent(
            futureFn: futureFn.futureFn,
            overlayPath: _previous?.filePath,
            videoEnabled: false,
            pickerEnabled: false));
    FeedMediasCompanion fm = await futureFn.future;
    return fm;
  }

  Widget _renderCurrent(BuildContext context) {
    return FeedFormParamLayout(
      title: 'Today\'s measure',
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
            FutureFn ff =
                BlocProvider.of<MainNavigatorBloc>(context).futureFn();
            BlocProvider.of<MainNavigatorBloc>(context).add(
                MainNavigateToImageCapturePlaybackEvent(media.filePath.value,
                    futureFn: ff.futureFn,
                    overlayPath: _previous?.filePath,
                    okButton: 'OK'));
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
}
