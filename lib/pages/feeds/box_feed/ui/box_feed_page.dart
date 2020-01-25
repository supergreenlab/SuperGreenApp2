import 'dart:async';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feeds/box_feed/bloc/box_drawer_bloc.dart';
import 'package:super_green_app/pages/feeds/box_feed/bloc/box_feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/ui/feed_page.dart';
import 'package:super_green_app/pages/home/bloc/home_navigator_bloc.dart';

class BoxFeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BoxFeedBloc, BoxFeedBlocState>(
      bloc: Provider.of<BoxFeedBloc>(context),
      builder: (BuildContext context, BoxFeedBlocState state) {
        String name = 'SuperGreenLab';
        if (state is BoxFeedBlocStateBox) {
          name = StringUtils.capitalize(state.box.name);
        }
        return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(name),
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            drawer: Drawer(child: this._drawerContent(context)),
            body: _renderFeed(context, state),
            floatingActionButton: state is BoxFeedBlocStateBox
                ? _renderSpeedDial(context, state)
                : null);
      },
    );
  }

  SpeedDial _renderSpeedDial(BuildContext context, BoxFeedBlocStateBox state) {
    return SpeedDial(
      marginBottom: 10,
      animationSpeed: 50,
      curve: Curves.bounceIn,
      backgroundColor: Colors.blueGrey,
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      overlayOpacity: 0.4,
      overlayColor: Colors.black,
      children: [
        _renderSpeedDialChild(
            'Video / photo',
            Colors.amber,
            _onSpeedDialSelected(context,
                ({pushAsReplacement = false}) => MainNavigateToImageCaptureEvent(pushAsReplacement: pushAsReplacement, nextRoute: MainNavigateToFeedMediaFormEvent(state.box)))),
        _renderSpeedDialChild(
            'Watering',
            Colors.blue,
            _onSpeedDialSelected(
                context, ({pushAsReplacement = false}) => MainNavigateToFeedWaterFormEvent(state.box, pushAsReplacement: pushAsReplacement))),
        _renderSpeedDialChild(
            'Light dimming',
            Colors.yellow,
            _onSpeedDialSelected(
                context, ({pushAsReplacement = false}) => MainNavigateToFeedLightFormEvent(state.box, pushAsReplacement: pushAsReplacement))),
        _renderSpeedDialChild(
            'Ventilation',
            Colors.grey,
            _onSpeedDialSelected(
                context, ({pushAsReplacement = false}) => MainNavigateToFeedVentilationFormEvent(state.box, pushAsReplacement: pushAsReplacement))),
        _renderSpeedDialChild(
            'Defoliation',
            Colors.green,
            _onSpeedDialSelected(
                context, ({pushAsReplacement = false}) => MainNavigateToFeedDefoliationFormEvent(state.box, pushAsReplacement: pushAsReplacement))),
        _renderSpeedDialChild(
            'Topping',
            Colors.blueGrey,
            _onSpeedDialSelected(
                context, ({pushAsReplacement = false}) => MainNavigateToFeedToppingFormEvent(state.box, pushAsReplacement: pushAsReplacement))),
        _renderSpeedDialChild(
            'Veg/Bloom',
            Colors.orange,
            _onSpeedDialSelected(
                context, ({pushAsReplacement = false}) => MainNavigateToFeedScheduleFormEvent(state.box, pushAsReplacement: pushAsReplacement))),
      ],
    );
  }

  SpeedDialChild _renderSpeedDialChild(
      String label, Color color, void Function() navigateTo) {
    return SpeedDialChild(
      backgroundColor: color,
      labelWidget: Text(label, style: TextStyle(color: Colors.white)),
      onTap: navigateTo,
    );
  }

  void Function() _onSpeedDialSelected(
      BuildContext context, MainNavigatorEvent Function({bool pushAsReplacement}) navigatorEvent) {
    return () =>
        BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToTipEvent(navigatorEvent(pushAsReplacement: true)));
  }

  Widget _renderFeed(BuildContext context, BoxFeedBlocState state) {
    if (state is BoxFeedBlocStateBox) {
      return BlocProvider(
        create: (context) => FeedBloc(state.box.feed),
        child: FeedPage(),
      );
    } else if (state is BoxFeedBlocStateNoBox) {
      return Text('No box yet', style: TextStyle(color: Colors.white));
    }
    return Text(
      'Box loading',
      style: TextStyle(color: Colors.white),
    );
  }

  Widget _drawerContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          height: 120,
          child: DrawerHeader(
              child: Row(children: <Widget>[
            SizedBox(
              width: 40,
              height: 40,
              child: SvgPicture.asset("assets/super_green_lab_vertical.svg"),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text('Box list',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ])),
        ),
        Expanded(
          child: _boxList(context),
        ),
        Divider(),
        Container(
            child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                    child: Column(
                  children: <Widget>[
                    ListTile(
                        leading: Icon(Icons.add_circle),
                        title: Text('Add new box'),
                        onTap: () => _onAddBox(context)),
                  ],
                ))))
      ],
    );
  }

  Widget _boxList(BuildContext context) {
    return BlocBuilder<BoxDrawerBloc, BoxDrawerBlocState>(
      bloc: Provider.of<BoxDrawerBloc>(context),
      condition: (previousState, state) =>
          state is BoxDrawerBlocStateLoadingBoxList ||
          state is BoxDrawerBlocStateBoxListUpdated,
      builder: (BuildContext context, BoxDrawerBlocState state) {
        List<Box> boxes = List();
        if (state is BoxDrawerBlocStateBoxListUpdated) {
          boxes = state.boxes;
        }
        return ListView(
          children: boxes
              .map((b) => ListTile(
                    onTap: () => _selectBox(context, b),
                    title: Text('${b.name}'),
                  ))
              .toList(),
        );
      },
    );
  }

  void _selectBox(BuildContext context, Box box) {
    //ignore: close_sinks
    HomeNavigatorBloc navigatorBloc =
        BlocProvider.of<HomeNavigatorBloc>(context);
    Navigator.pop(context);
    Timer(Duration(milliseconds: 250),
        () => navigatorBloc.add(HomeNavigateToBoxFeedEvent(box)));
  }

  void _onAddBox(BuildContext context) {
    BlocProvider.of<MainNavigatorBloc>(context)
        .add(MainNavigateToNewBoxInfosEvent());
  }
}
