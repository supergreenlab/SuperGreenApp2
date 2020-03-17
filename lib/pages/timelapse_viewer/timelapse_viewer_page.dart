import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/timelapse_viewer/timelapse_viewer_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class TimelapseViewerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<TimelapseViewerBloc, TimelapseViewerBlocState>(
        listener: (BuildContext context, TimelapseViewerBlocState state) {},
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
                          .add(MainNavigateToTimelapseSetup(state.box));
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
    int i = 0;
    return ListView(
      children: state.timelapses.map<Widget>((t) {
        return Image.memory(state.images[i++]);
      }).toList(),
    );
  }
}
