import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/app_init/bloc/app_init_bloc.dart';
import 'package:super_green_app/pages/app_init/ui/app_init_page.dart';

Map<int, Color> primaryColor = {
  50: Color.fromRGBO(69, 69, 69, .1),
  100: Color.fromRGBO(69, 69, 69, .2),
  200: Color.fromRGBO(69, 69, 69, .3),
  300: Color.fromRGBO(69, 69, 69, .4),
  400: Color.fromRGBO(69, 69, 69, .5),
  500: Color.fromRGBO(69, 69, 69, .6),
  600: Color.fromRGBO(69, 69, 69, .7),
  700: Color.fromRGBO(69, 69, 69, .8),
  800: Color.fromRGBO(69, 69, 69, .9),
  900: Color.fromRGBO(69, 69, 69, 1),
};

Map<int, Color> secondaryColor = {
  50: Color.fromRGBO(59, 179, 11, .1),
  100: Color.fromRGBO(59, 179, 11, .2),
  200: Color.fromRGBO(59, 179, 11, .3),
  300: Color.fromRGBO(59, 179, 11, .4),
  400: Color.fromRGBO(59, 179, 11, .5),
  500: Color.fromRGBO(59, 179, 11, .6),
  600: Color.fromRGBO(59, 179, 11, .7),
  700: Color.fromRGBO(59, 179, 11, .8),
  800: Color.fromRGBO(59, 179, 11, .9),
  900: Color.fromRGBO(59, 179, 11, 1),
};

void main() async {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  runApp(BlocProvider<MainNavigatorBloc>(
      create: (context) => MainNavigatorBloc(navigatorKey: _navigatorKey),
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        title: 'SuperGreenLab',
        theme: ThemeData(
            fontFamily: 'Roboto',
            primaryColor: Color(0XFF212845),
            scaffoldBackgroundColor: Color(0XFFEFEFEF),
            primarySwatch: MaterialColor(0xFF454545, primaryColor),
            buttonColor: Color(0xff3bb30b),
            accentColor: Colors.green,
            buttonTheme: ButtonThemeData(
              shape: RoundedRectangleBorder(),
              textTheme: ButtonTextTheme.accent,
            )),
        home: BlocProvider<AppInitBloc>(
          create: (context) => AppInitBloc(),
          child: AppInitPage(),
        ),
      )));
}
