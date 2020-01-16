import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/main/main_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

void main() async {
  runApp(BlocProvider<MainNavigatorBloc>(
      create: (context) => MainNavigatorBloc(navigatorKey),
      child: MainPage(navigatorKey)));
}
