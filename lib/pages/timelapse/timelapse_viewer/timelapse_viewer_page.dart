import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
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
  List<Matrix4> _matrix = [];

  @override
  Widget build(BuildContext context) {
    return BlocListener<TimelapseViewerBloc, TimelapseViewerBlocState>(
        listener: (BuildContext context, TimelapseViewerBlocState state) {
          if (state is TimelapseViewerBlocStateLoaded) {
            _matrix =
                state.images.map<Matrix4>((_) => Matrix4.identity()).toList();
          }
        },
        child: BlocBuilder<TimelapseViewerBloc, TimelapseViewerBlocState>(
            bloc: BlocProvider.of<TimelapseViewerBloc>(context),
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
            }));
  }

  Widget _renderTimelapses(
      BuildContext context, TimelapseViewerBlocStateLoaded state) {
    return ListView.builder(
      itemCount: state.images.length + 1,
      itemBuilder: (context, index) {
        if (index >= state.images.length) {
          return _renderAdd(context, state);
        }
        return MatrixGestureDetector(
            onMatrixUpdate: (Matrix4 m, Matrix4 tm, Matrix4 sm, Matrix4 rm) {
              setState(() {
                _matrix[index] =
                    MatrixGestureDetector.compose(_matrix[index], tm, sm, null);
              });
            },
            onGestureEnd: () {
              setState(() {
                _matrix[index] = Matrix4.identity();
              });
            },
            child: SizedBox(
                height: 270,
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
                  Transform(
                      transform: _matrix[index],
                      child: Image.memory(
                        state.images[index],
                        fit: BoxFit.cover,
                      )),
                ])));
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
}
