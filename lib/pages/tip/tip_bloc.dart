
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class TipBlocEvent extends Equatable {}

class TipBlocState extends Equatable {

  final MainNavigateToFeedFormEvent nextRoute;

  TipBlocState(this.nextRoute);

  @override
  List<Object> get props => [nextRoute];

}

class TipBloc extends Bloc<TipBlocEvent,TipBlocState> {
  final MainNavigateToTipEvent _args;

  TipBloc(this._args);

  @override
  TipBlocState get initialState => TipBlocState(_args.nextRoute);

  @override
  Stream<TipBlocState> mapEventToState(TipBlocEvent event) async* {}

}