import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/pages/home_page/bloc/home_bloc.dart';
import 'package:super_green_app/pages/home_page/ui/home_page.dart';

abstract class MainNavigatorAction extends Equatable {}

class MainNavigateToHomeEvent extends MainNavigatorAction {
  @override
  List<Object> get props => [];
}

class MainNavigatorActionPop extends MainNavigatorAction {
  @override
  List<Object> get props => [];
}

class MainNavigatorBloc extends Bloc<MainNavigatorAction, dynamic> {
  final GlobalKey<NavigatorState> navigatorKey;
  MainNavigatorBloc({this.navigatorKey});

  @override
  dynamic get initialState => 0;

  @override
  Stream<dynamic> mapEventToState(MainNavigatorAction event) async* {
    if (event is MainNavigatorActionPop) {
      navigatorKey.currentState.pop();
    } else if (event is MainNavigateToHomeEvent) {
      navigatorKey.currentState.pushReplacement(MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => MainBloc(),
                child: HomePage(),
              )));
    }
  }
}
