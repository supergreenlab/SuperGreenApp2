import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:super_green_app/data/analytics/matomo.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/timelapse/timelapse_howto/timelapse_howto_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TimelapseHowtoPage extends TraceableStatefulWidget {
  @override
  _TimelapseHowtoPageState createState() => _TimelapseHowtoPageState();
}

class _TimelapseHowtoPageState extends State<TimelapseHowtoPage> {
  YoutubePlayerController _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: '0vjswZQ0rk4',
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: true,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimelapseHowtoBloc, TimelapseHowtoBlocState>(
      builder: (BuildContext context, state) {
        Widget body = Column(children: [
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Column(
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
                          child: MarkdownBody(
                              data:
                                  '**Support us** by using this **link**,\nget a **bonus** pre-configured **sd-card** ❤️',
                              styleSheet: MarkdownStyleSheet(
                                  textAlign: WrapAlignment.center, p: TextStyle(fontSize: 22, color: Colors.black)))),
                      GreenButton(
                        title: 'SHOP NOW',
                        onPressed: () {
                          launch('https://www.supergreenlab.com');
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          onPressed: () {
                            BlocProvider.of<MainNavigatorBloc>(context)
                                .add(MainNavigateToTimelapseSetup(state.plant, pushAsReplacement: true));
                          },
                          child: Text(
                            'ADD A NEW ONE',
                            style: TextStyle(color: Colors.blue, fontSize: 22),
                          ),
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          BlocProvider.of<MainNavigatorBloc>(context)
                              .add(MainNavigateToTimelapseConnect(state.plant, pushAsReplacement: true));
                        },
                        child: Text(
                          'CONNECT ONE',
                          style: TextStyle(color: Colors.blue, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]);

        return Scaffold(
            appBar: SGLAppBar(
              'Timelapse',
            ),
            backgroundColor: Colors.white,
            body: AnimatedSwitcher(duration: Duration(milliseconds: 200), child: body));
      },
    );
  }
}
