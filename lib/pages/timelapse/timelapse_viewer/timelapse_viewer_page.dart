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
        cubit: BlocProvider.of<TimelapseViewerBloc>(context),
        builder: (BuildContext context, TimelapseViewerBlocState state) {
          Widget body;
          List<Widget> actions;
          if (state is TimelapseViewerBlocStateLoading) {
            body = FullscreenLoading(title: 'Loading..');
          } else if (state is TimelapseViewerBlocStateLoaded) {
            body = _renderTimelapses(context, state);
            actions = [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  BlocProvider.of<MainNavigatorBloc>(context)
                      .add(MainNavigateToTimelapseSetup(state.plant));
                },
              ),
            ];
          }
          return Scaffold(
              appBar: SGLAppBar(
                'Timelapses',
                actions: actions,
              ),
              backgroundColor: Colors.white,
              body: AnimatedSwitcher(
                  duration: Duration(milliseconds: 200), child: body));
        });
  }

  Widget _renderTimelapses(
      BuildContext context, TimelapseViewerBlocStateLoaded state) {
    return ListView.builder(
      itemCount: state.images.length + 1,
      itemBuilder: (context, index) {
        if (index >= state.images.length) {
          return _renderAdd(context, state);
        }
        return InkWell(
          onTap: () {
            BlocProvider.of<MainNavigatorBloc>(context).add(
                MainNavigateToFullscreenPicture(
                    state.timelapses[index].id, state.images[index]));
          },
          onLongPress: () {
            _deleteTimelapse(context, state.timelapses[index]);
          },
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
                        Text(
                            'Pictures are uploaded every 10min,\nPlease wait..',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ))
                  ],
                ),
                Center(
                  child: Image.memory(
                    state.images[index],
                    fit: BoxFit.contain,
                  ),
                ),
              ])),
        );
      },
    );
  }

  Widget _renderAdd(
      BuildContext context, TimelapseViewerBlocStateLoaded state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Column(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 24),
                  child: MarkdownBody(
                      data:
                          'Want another one?\n**Support us** by using this **link** ❤️',
                      styleSheet: MarkdownStyleSheet(
                          textAlign: WrapAlignment.center,
                          p: TextStyle(fontSize: 22, color: Colors.black)))),
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
                    BlocProvider.of<MainNavigatorBloc>(context).add(
                        MainNavigateToTimelapseSetup(state.plant,
                            pushAsReplacement: true));
                  },
                  child: Text(
                    'ADD A NEW ONE',
                    style: TextStyle(color: Colors.blue, fontSize: 22),
                  ),
                ),
              ),
              FlatButton(
                onPressed: () {
                  BlocProvider.of<MainNavigatorBloc>(context).add(
                      MainNavigateToTimelapseConnect(state.plant,
                          pushAsReplacement: true));
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
    );
  }

  void _deleteTimelapse(BuildContext context, Timelapse timelapse) async {
    bool confirm = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete timelapse ${timelapse.uploadName}?'),
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
      BlocProvider.of<TimelapseViewerBloc>(context)
          .add(TimelapseViewerBlocEventDelete(timelapse));
    }
  }
}
