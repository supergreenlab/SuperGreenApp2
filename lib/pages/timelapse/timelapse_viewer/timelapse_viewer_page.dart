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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/timelapse/timelapse_viewer/timelapse_viewer_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:url_launcher/url_launcher.dart';

class TimelapseViewerPage extends StatefulWidget {
  @override
  _TimelapseViewerPageState createState() => _TimelapseViewerPageState();
}

class _TimelapseViewerPageState extends State<TimelapseViewerPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimelapseViewerBloc, TimelapseViewerBlocState>(
        bloc: BlocProvider.of<TimelapseViewerBloc>(context),
        builder: (BuildContext context, TimelapseViewerBlocState state) {
          Widget body = FullscreenLoading(
            title: 'Loading..',
          );
          if (state is TimelapseViewerBlocStateLoading) {
            body = FullscreenLoading(title: 'Loading..');
          } else if (state is TimelapseViewerBlocStateLoaded) {
            if (state.timelapses.length != 0) {
              body = _renderTimelapses(context, state);
            } else {
              body = _renderEmpty(context, state);
            }
          }
          return Scaffold(
              appBar: SGLAppBar(
                'Live cam 🎥',
                backgroundColor: Color(0xff063047),
                titleColor: Colors.white,
                iconColor: Colors.white,
              ),
              backgroundColor: Colors.white,
              body: AnimatedSwitcher(duration: Duration(milliseconds: 200), child: body));
        });
  }

  Widget _renderTimelapses(BuildContext context, TimelapseViewerBlocStateLoaded state) {
    return ListView.builder(
      itemCount: state.images.length + 1,
      itemBuilder: (context, index) {
        if (index >= state.images.length) {
          return _renderAdd(context, state);
        }
        return InkWell(
            onTap: () {
              BlocProvider.of<MainNavigatorBloc>(context)
                  .add(MainNavigateToFullscreenPicture(state.timelapses[index].id, state.images[index]));
            },
            onLongPress: () {
              _deleteTimelapse(context, state.timelapses[index]);
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: 300,
                child: Stack(children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                          child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(
                              strokeWidth: 4.0,
                            ),
                          ),
                          Text('Pictures are uploaded every 10min,\nPlease wait..',
                              textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                        ],
                      ))
                    ],
                  ),
                  Center(
                    child: Container(
                        decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(7)),
                        clipBehavior: Clip.hardEdge,
                        child: Image.memory(
                          state.images[index],
                          fit: BoxFit.contain,
                        )),
                  ),
                ]),
              ),
            ));
      },
    );
  }

  Widget _renderAdd(BuildContext context, TimelapseViewerBlocStateLoaded state) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
                    child: MarkdownBody(
                        data: 'Want another one?',
                        styleSheet: MarkdownStyleSheet(
                            textAlign: WrapAlignment.center, p: TextStyle(fontSize: 22, color: Colors.black)))),
                GreenButton(
                  title: 'SHOP NOW',
                  onPressed: () {
                    launchUrl(Uri.parse('https://www.supergreenlab.com'));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderEmpty(BuildContext context, TimelapseViewerBlocStateLoaded state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Column(
            children: <Widget>[
              Text("🎥", style: TextStyle(fontSize: 90)),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
                  child: MarkdownBody(
                      data:
                          '**Keep an eye on your grow**, setup a **live cam**! The system will post **daily and weekly timelapses** of your plants in the feed. Timelapse videos are a **very efficient** way to **spot problems before they appear**.',
                      styleSheet: MarkdownStyleSheet(
                          textAlign: WrapAlignment.center, p: TextStyle(fontSize: 22, color: Colors.black)))),
              GreenButton(
                title: 'VIEW GUIDE',
                onPressed: () {
                  launchUrl(Uri.parse('https://www.supergreenlab.com/guide/how-to-setup-a-remote-live-camera'));
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _deleteTimelapse(BuildContext context, Timelapse timelapse) async {
    bool? confirm = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete timelapse ${timelapse.uploadName}?'),
            content: Text('This can\'t be reverted. Continue?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text('NO'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text('YES'),
              ),
            ],
          );
        });
    if (confirm ?? false) {
      BlocProvider.of<TimelapseViewerBloc>(context).add(TimelapseViewerBlocEventDelete(timelapse));
    }
  }
}
