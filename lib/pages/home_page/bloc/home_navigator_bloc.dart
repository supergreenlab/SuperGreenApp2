import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/pages/home_page/bloc/home_bloc.dart';
import 'package:super_green_app/pages/home_page/ui/main_page.dart';

abstract class HomeNavigatorAction extends Equatable {}

class HomeNavigateToHomeEvent extends HomeNavigatorAction {
  @override
  List<Object> get props => [];
}

class HomeNavigatorActionPop extends HomeNavigatorAction {
  @override
  List<Object> get props => [];
}

class HomeNavigatorBloc extends Bloc<HomeNavigatorAction, dynamic> {
  final GlobalKey<NavigatorState> navigatorKey;
  HomeNavigatorBloc({this.navigatorKey});

  @override
  dynamic get initialState => 0;

  @override
  Stream<dynamic> mapEventToState(HomeNavigatorAction event) async* {
    if (event is HomeNavigatorActionPop) {
      navigatorKey.currentState.pop();
    } else if (event is HomeNavigateToHomeEvent) {
      navigatorKey.currentState.pushReplacement(MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => MainBloc(),
                child: MainPage(),
              )));
    }
  }
}
