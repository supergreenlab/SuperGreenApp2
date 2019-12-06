import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/app_init/bloc/app_init_bloc.dart';
import 'package:super_green_app/pages/app_init/ui/app_init_page.dart';

void main() async {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  runApp(BlocProvider<MainNavigatorBloc>(
      create: (context) => MainNavigatorBloc(navigatorKey: _navigatorKey),
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        title: 'SuperGreenLab',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            buttonTheme: ButtonThemeData(
              buttonColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(),
              textTheme: ButtonTextTheme.accent,
            )),
        home: BlocProvider<AppInitBloc>(
          create: (context) => AppInitBloc(),
          child: AppInitPage(),
        ),
      )));
}
