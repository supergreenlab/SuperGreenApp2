import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('SuperGreenLab'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      drawer: Drawer(child: this._drawerContent(context)),
      body: BlocBuilder<BoxFeedBloc, BoxFeedBlocState>(
        bloc: Provider.of<BoxFeedBloc>(context),
        builder: (BuildContext context, BoxFeedBlocState state) {
          return _renderFeed(context, state);
        },
      ),
    );
  }

  Widget _renderFeed(BuildContext context, BoxFeedBlocState state) {
    if (state is BoxFeedBlocStateFeedLoaded) {
      return BlocProvider(
        create: (context) => FeedBloc(state.box.feed),
        child: FeedPage(),
      );
    }
    return Text('Box loading');
  }

  Widget _drawerContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DrawerHeader(
            child: Column(children: <Widget>[
          Expanded(
            child: SizedBox(
              width: 100,
              height: 100,
              child: SvgPicture.asset("assets/super_green_lab_vertical.svg"),
            ),
          ),
        ])),
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
                    ListTile(
                        leading: Icon(Icons.settings), title: Text('Settings')),
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
