import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/main/main_page.dart';

void main() async {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  runApp(BlocProvider<MainNavigatorBloc>(
      create: (context) => MainNavigatorBloc(navigatorKey: navigatorKey),
      child: MainPage(navigatorKey)));
}
